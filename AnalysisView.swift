import SwiftUI

struct AnalysisView: View {
    @EnvironmentObject var glowViewModel: GlowGirlViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPage = 0
    @State private var sparkleAnimation = false
    
    var body: some View {
        ZStack {
            // Dreamy gradient background
            LinearGradient(
                colors: [Color.pink.opacity(0.1), Color.purple.opacity(0.15), Color.orange.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom header
                VStack(spacing: 8) {
                    HStack {
                        Button("close") {
                            dismiss()
                        }
                        .font(.caption)
                        .foregroundColor(.purple.opacity(0.8))
                        
                        Spacer()
                        
                        Text("ur tea analysis ✨")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.pink, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Spacer()
                        
                        Button("new tea") {
                            glowViewModel.resetAnalysis()
                            dismiss()
                        }
                        .font(.caption)
                        .foregroundColor(.pink.opacity(0.8))
                    }
                    .padding(.horizontal, 25)
                    .padding(.top, 15)
                    
                    // Sparkle divider
                    HStack {
                        ForEach(0..<7, id: \.self) { index in
                            Image(systemName: "sparkle")
                                .font(.system(size: 8))
                                .foregroundColor(.pink.opacity(0.6))
                                .scaleEffect(sparkleAnimation ? 1.2 : 0.8)
                                .animation(
                                    .easeInOut(duration: 1.5)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.1),
                                    value: sparkleAnimation
                                )
                        }
                    }
                    .padding(.bottom, 10)
                }
                
                // Page content
                TabView(selection: $selectedPage) {
                    // Page 1: Life Analysis
                    LifeAnalysisPage()
                        .tag(0)
                    
                    // Page 2: Glow Up Plan
                    GlowUpPlanPage()
                        .tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Custom bottom navigation
                HStack(spacing: 40) {
                    // Page 1 button
                    VStack(spacing: 4) {
                        Button(action: { selectedPage = 0 }) {
                            VStack(spacing: 6) {
                                Image(systemName: "heart.text.square.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(selectedPage == 0 ? .pink : .pink.opacity(0.4))
                                Text("my story")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(selectedPage == 0 ? .pink : .pink.opacity(0.4))
                            }
                        }
                        
                        if selectedPage == 0 {
                            Circle()
                                .fill(.pink)
                                .frame(width: 4, height: 4)
                        }
                    }
                    
                    // Page 2 button
                    VStack(spacing: 4) {
                        Button(action: { selectedPage = 1 }) {
                            VStack(spacing: 6) {
                                Image(systemName: "sparkles.rectangle.stack.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(selectedPage == 1 ? .purple : .purple.opacity(0.4))
                                Text("glow up")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(selectedPage == 1 ? .purple : .purple.opacity(0.4))
                            }
                        }
                        
                        if selectedPage == 1 {
                            Circle()
                                .fill(.purple)
                                .frame(width: 4, height: 4)
                        }
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            sparkleAnimation = true
        }
    }
}

// MARK: - Page 1: Life Analysis
struct LifeAnalysisPage: View {
    @State private var emotionallyAvailable = true
    @State private var pulseAnimation = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Your vibe category
                VStack(spacing: 15) {
                    Text("ur current main character era")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.pink)
                    
                    VStack(spacing: 12) {
                        Text("💔 the heartbreak bestie")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.purple)
                        
                        Text("you're in your healing girl era - we see you bestie. time to glow up and show them what they lost 💅")
                            .font(.subheadline)
                            .foregroundColor(.purple.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.pink.opacity(0.1))
                            .stroke(Color.pink.opacity(0.3), lineWidth: 1)
                    )
                }
                
                // Friend recommendations
                VStack(alignment: .leading, spacing: 15) {
                    Text("ur tribe of besties 👯‍♀️")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    
                    Text("other girlies going thru the same thing:")
                        .font(.caption)
                        .foregroundColor(.orange.opacity(0.8))
                    
                    LazyVStack(spacing: 12) {
                        ForEach(mockFriends, id: \.id) { friend in
                            FriendCard(friend: friend)
                        }
                    }
                }
                
                // Life timeline
                VStack(alignment: .leading, spacing: 15) {
                    Text("ur love story timeline 💕")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                    
                    TimelineView()
                }
                
                // Dating recommendations
                VStack(alignment: .leading, spacing: 15) {
                    Text("ur next chapter energy ✨")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.pink)
                    
                    VStack(spacing: 12) {
                        HStack {
                            Text("emotionally available for love?")
                                .font(.subheadline)
                                .foregroundColor(.purple)
                            
                            Spacer()
                            
                            Toggle("", isOn: $emotionallyAvailable)
                                .tint(.pink)
                        }
                        
                        if emotionallyAvailable {
                            DatingRecsView()
                        } else {
                            VStack(spacing: 8) {
                                Text("healing era activated 🌸")
                                    .font(.headline)
                                    .foregroundColor(.pink)
                                Text("focus on urself first bestie - the right person will come when ur ready 💝")
                                    .font(.caption)
                                    .foregroundColor(.purple.opacity(0.8))
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.pink.opacity(0.1))
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }
}

// MARK: - Page 2: Glow Up Plan
struct GlowUpPlanPage: View {
    @State private var rashiAnimation = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Life phase color
                VStack(spacing: 15) {
                    Text("ur life phase color 🌈")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [.purple, .pink, .orange.opacity(0.8)],
                                    center: .center,
                                    startRadius: 20,
                                    endRadius: 80
                                )
                            )
                            .frame(width: 120, height: 120)
                            .scaleEffect(rashiAnimation ? 1.05 : 1.0)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: rashiAnimation)
                        
                        Text("phoenix rising")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    Text("transformation purple - ur about to rise from the ashes bestie 🔥")
                        .font(.subheadline)
                        .foregroundColor(.purple.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                
                // Rashi predictions
                RashiPredictionCard()
                
                // Today's fit
                TodaysFitSection()
                
                // Glow up intensity
                GlowUpIntensityCard()
                
                // Future predictions
                FuturePredictionsCard()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
        .onAppear {
            rashiAnimation = true
        }
    }
}

// MARK: - Supporting Views

struct FriendCard: View {
    let friend: MockFriend
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.pink.opacity(0.6), .purple.opacity(0.4)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 40, height: 40)
                .overlay(
                    Text(friend.initial)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(friend.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.purple)
                
                Text(friend.situation)
                    .font(.caption)
                    .foregroundColor(.purple.opacity(0.7))
                    .lineLimit(2)
            }
            
            Spacer()
            
            Button("connect") {
                // Connect action
            }
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(.orange)
            )
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.8))
                .shadow(color: .orange.opacity(0.2), radius: 5, x: 0, y: 2)
        )
    }
}

struct TimelineView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            ForEach(mockTimelineEvents, id: \.id) { event in
                HStack(alignment: .top, spacing: 12) {
                    Circle()
                        .fill(event.color)
                        .frame(width: 12, height: 12)
                        .overlay(
                            Circle()
                                .stroke(.white, lineWidth: 2)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(event.title)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.purple)
                        
                        Text(event.description)
                            .font(.caption)
                            .foregroundColor(.purple.opacity(0.7))
                    }
                    
                    Spacer()
                }
            }
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.purple.opacity(0.05))
                .stroke(Color.purple.opacity(0.2), lineWidth: 1)
        )
    }
}

struct DatingRecsView: View {
    var body: some View {
        VStack(spacing: 12) {
            ForEach(mockDatingRecs, id: \.type) { rec in
                HStack(spacing: 12) {
                    Text(rec.emoji)
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(rec.type)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.pink)
                        
                        Text(rec.description)
                            .font(.caption)
                            .foregroundColor(.pink.opacity(0.8))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.pink.opacity(0.1))
                )
            }
        }
    }
}

struct RashiPredictionCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("ur rashi says... ♍")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                
                Spacer()
            }
            
            Text("virgo energy is calling for a complete rebrand bestie. time to organize ur life and serve looks while doing it ✨")
                .font(.subheadline)
                .foregroundColor(.purple.opacity(0.8))
                .lineSpacing(2)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.purple.opacity(0.1))
                .stroke(Color.purple.opacity(0.3), lineWidth: 1)
        )
    }
}

struct TodaysFitSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("today's main character fit 💅")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.pink)
            
            VStack(spacing: 12) {
                FitRecommendation(
                    category: "ur power look",
                    item: "structured blazer + gold jewelry",
                    reason: "command attention and respect",
                    intensity: "dramatic change",
                    color: .orange
                )
                
                FitRecommendation(
                    category: "ur glow moment",
                    item: "bold red lipstick + winged liner",
                    reason: "project confidence after heartbreak",
                    intensity: "soft transformation",
                    color: .pink
                )
            }
        }
    }
}

struct FitRecommendation: View {
    let category: String
    let item: String
    let reason: String
    let intensity: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(category)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(color)
            
            Text(item)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.purple)
            
            Text("why: \(reason)")
                .font(.caption)
                .foregroundColor(.purple.opacity(0.7))
            
            HStack {
                Text(intensity)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(color.opacity(0.8))
                    )
                
                Spacer()
            }
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(color.opacity(0.1))
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

struct GlowUpIntensityCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ur transformation level 🔥")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.orange)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("phoenix mode activated")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                    
                    Text("dramatic change recommended - ur ready for a complete rebrand bestie")
                        .font(.caption)
                        .foregroundColor(.orange.opacity(0.8))
                }
                
                Spacer()
                
                Text("🔥")
                    .font(.title)
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.orange.opacity(0.1))
                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
        )
    }
}

struct FuturePredictionsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("what the stars see for u ⭐")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.purple)
            
            VStack(spacing: 12) {
                PredictionRow(timeframe: "next month", prediction: "someone from ur past might slide back into ur dms 👀", color: .pink)
                PredictionRow(timeframe: "3 months", prediction: "major glow up complete - ur gonna be unrecognizable bestie ✨", color: .orange)
                PredictionRow(timeframe: "6 months", prediction: "new love interest enters ur orbit - they're gonna be obsessed 💕", color: .purple)
            }
        }
    }
}

struct PredictionRow: View {
    let timeframe: String
    let prediction: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(timeframe)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(color)
                )
            
            Text(prediction)
                .font(.caption)
                .foregroundColor(.purple.opacity(0.8))
                .lineLimit(nil)
            
            Spacer()
        }
    }
}

// MARK: - Mock Data
struct MockFriend {
    let id = UUID()
    let name: String
    let initial: String
    let situation: String
}

struct MockTimelineEvent {
    let id = UUID()
    let title: String
    let description: String
    let color: Color
}

struct MockDatingRec {
    let type: String
    let description: String
    let emoji: String
}

let mockFriends = [
    MockFriend(name: "maya", initial: "M", situation: "just got out of a 3 year relationship, focusing on self love era"),
    MockFriend(name: "zara", initial: "Z", situation: "heartbroken but thriving - serving looks and healing"),
    MockFriend(name: "aria", initial: "A", situation: "phoenix rising from toxic relationship ashes")
]

let mockTimelineEvents = [
    MockTimelineEvent(title: "college sweethearts era", description: "met ur first love - pure and innocent vibes", color: .pink),
    MockTimelineEvent(title: "the heartbreak", description: "they chose someone else - ur healing journey begins", color: .purple),
    MockTimelineEvent(title: "glow up season", description: "time to become the main character of ur own story", color: .orange)
]

let mockDatingRecs = [
    MockDatingRec(type: "the healer", description: "someone emotionally intelligent who helps u grow", emoji: "🌱"),
    MockDatingRec(type: "the adventure buddy", description: "brings excitement and new experiences to ur life", emoji: "✨"),
    MockDatingRec(type: "the secure one", description: "gives u the stability and consistency u deserve", emoji: "🏠")
]

#Preview {
    AnalysisView()
        .environmentObject(GlowGirlViewModel())
}
