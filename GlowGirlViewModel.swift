import SwiftUI
import Foundation

// MARK: - App State Management
enum AppState {
    case dashboard
    case chatting
    case analyzing
    case recommendations
}

class GlowGirlViewModel: ObservableObject {
    @Published var currentState: AppState = .dashboard
    @Published var chatMessages: [ChatMessage] = []
    @Published var timeRemaining: Int = 300 // 5 minutes in seconds
    @Published var isTimerRunning = false
    @Published var teaAnalysis: TeaAnalysis?
    @Published var recommendations: [BeautyRecommendation] = []
    @Published var isLoading = false
    
    private var timer: Timer?
    
    // Start the 5-minute tea spilling session
    func startTeaSession() {
        currentState = .chatting
        timeRemaining = 300
        isTimerRunning = true
        chatMessages = [
            ChatMessage(
                id: UUID(),
                content: "Hey gorgeous! ✨ You've got 5 minutes to spill ALL the tea about your love life. Don't hold back - I'm here to help you glow up based on whatever's going on! What's the situation? 💕",
                isFromUser: false,
                timestamp: Date()
            )
        ]
        
        startTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            DispatchQueue.main.async {
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.finishTeaSession()
                }
            }
        }
    }
    
    private func finishTeaSession() {
        timer?.invalidate()
        isTimerRunning = false
        currentState = .analyzing
        
        // Send all messages for analysis
        Task {
            await analyzeTeaAndGetRecommendations()
        }
    }
    
    func sendMessage(_ content: String) async {
        let userMessage = ChatMessage(
            id: UUID(),
            content: content,
            isFromUser: true,
            timestamp: Date()
        )
        
        await MainActor.run {
            chatMessages.append(userMessage)
        }
        
        // Send to OpenAI and get response
        do {
            let response = try await OpenAIService.shared.sendMessage(content, chatHistory: chatMessages)
            let botMessage = ChatMessage(
                id: UUID(),
                content: response,
                isFromUser: false,
                timestamp: Date()
            )
            
            await MainActor.run {
                chatMessages.append(botMessage)
            }
        } catch {
            print("Error sending message: \(error)")
        }
    }
    
    private func analyzeTeaAndGetRecommendations() async {
        await MainActor.run {
            isLoading = true
        }
        
        do {
            // 1. Get tea analysis from OpenAI
            let analysis = try await OpenAIService.shared.analyzeTeaSession(chatMessages)
            
            // 2. Save conversation as vector embedding
            try await VectorService.shared.saveConversationEmbedding(chatMessages)
            
            // 3. Get beauty recommendations based on analysis
            let recs = try await BeautyRecommendationService.shared.getRecommendations(for: analysis)
            
            await MainActor.run {
                self.teaAnalysis = analysis
                self.recommendations = recs
                self.currentState = .recommendations
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.isLoading = false
                print("Error analyzing tea: \(error)")
            }
        }
    }
    
    func resetSession() {
        currentState = .dashboard
        chatMessages = []
        timeRemaining = 300
        isTimerRunning = false
        teaAnalysis = nil
        recommendations = []
        timer?.invalidate()
    }
}

// MARK: - Data Models
struct ChatMessage: Identifiable, Codable {
    let id: UUID
    let content: String
    let isFromUser: Bool
    let timestamp: Date
}

struct TeaAnalysis: Codable {
    let mood: String // "heartbroken", "excited", "confused", "empowered", etc.
    let situation: String // summary of their love life situation
    let vibe: String // the energy they need - "confidence boost", "self-love", "revenge glow", etc.
    let colorPalette: [String] // colors that match their energy
    let style: String // "edgy", "soft", "bold", "minimalist", etc.
}

struct BeautyRecommendation: Identifiable, Codable {
    let id = UUID()
    let category: RecommendationType
    let title: String
    let description: String
    let price: String?
    let imageURL: String?
    let productURL: String?
    let reasoning: String // why this matches their tea
}

enum RecommendationType: String, CaseIterable, Codable {
    case makeup = "Makeup"
    case skincare = "Skincare"
    case haircare = "Hair Care"
    case hairdye = "Hair Color"
    case clothing = "Style"
}

