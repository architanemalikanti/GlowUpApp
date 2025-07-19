//
//  MessageBubble.swift
//  GlowGirl
//
//  Created by Archita Nemalikanti on 6/23/25.
//

import SwiftUI

// MARK: - Message Bubble
struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer()
                Text(message.content)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.pink)
                    )
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity * 0.8, alignment: .trailing)
            } else {
                Text(message.content)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.gray.opacity(0.2))
                    )
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity * 0.8, alignment: .leading)
                Spacer()
            }
        }
    }
}

// MARK: - Analyzing View
struct AnalyzingView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.pink, Color.purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ProgressView()
                    .scaleEffect(2)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                
                Text("Analyzing your tea... ✨")
                    .foregroundColor(.white)
                    .font(.title2)
                    .bold()
                
                Text("Our AI is crafting the perfect glow-up recommendations just for you!")
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
    }
}

// MARK: - Recommendations View
struct RecommendationsView: View {
    @EnvironmentObject var glowViewModel: GlowGirlViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Analysis Summary
                    if let analysis = glowViewModel.teaAnalysis {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Your Tea Analysis 🍵")
                                .font(.title2)
                                .bold()
                            
                            Text("Mood: \(analysis.mood)")
                            Text("Vibe Check: \(analysis.vibe)")
                            Text("Style Direction: \(analysis.style)")
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.pink.opacity(0.1))
                        )
                    }
                    
                    // Recommendations by Category
                    ForEach(RecommendationType.allCases, id: \.self) { category in
                        let categoryRecs = glowViewModel.recommendations.filter { $0.category == category }
                        if !categoryRecs.isEmpty {
                            RecommendationSection(category: category, recommendations: categoryRecs)
                        }
                    }
                    
                    // Start Over Button
                    Button(action: {
                        glowViewModel.resetSession()
                    }) {
                        Text("Spill More Tea! 🍵")
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(.pink)
                            )
                    }
                    .padding(.top)
                }
                .padding()
            }
            .navigationTitle("Your Glow Up ✨")
        }
    }
}

// MARK: - Recommendation Section
struct RecommendationSection: View {
    let category: RecommendationType
    let recommendations: [BeautyRecommendation]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(category.rawValue)
                .font(.headline)
                .bold()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(recommendations) { rec in
                        RecommendationCard(recommendation: rec)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Recommendation Card
struct RecommendationCard: View {
    let recommendation: BeautyRecommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Product Image Placeholder
            RoundedRectangle(cornerRadius: 10)
                .fill(.gray.opacity(0.3))
                .frame(width: 150, height: 120)
                .overlay(
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                )
            
            Text(recommendation.title)
                .font(.subheadline)
                .bold()
                .lineLimit(2)
            
            Text(recommendation.reasoning)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(3)
            
            if let price = recommendation.price {
                Text(price)
                    .font(.caption)
                    .foregroundColor(.pink)
                    .bold()
            }
        }
        .frame(width: 150)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.white)
                .shadow(radius: 5)
        )
    }
}
