//
//  DashboardHomeView.swift
//  GlowGirl
//
//  Created by Archita Nemalikanti on 6/23/25.
//

import SwiftUI

// MARK: - Dashboard Home
struct DashboardHomeView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var glowViewModel: GlowGirlViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.pink, Color.purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Header
                VStack(spacing: 15) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 60))
                        .foregroundStyle(.white)
                    
                    Text("Ready to Glow? ✨")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .bold()
                    
                    Text("Spill the tea about your love life and get personalized glow-up recommendations!")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                // Start Session Button
                VStack(spacing: 20) {
                    VStack(spacing: 10) {
                        Text("Here's how it works:")
                            .foregroundColor(.white)
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("⏰")
                                Text("5 minutes to spill ALL the tea")
                            }
                            HStack {
                                Text("🤖")
                                Text("AI analyzes your situation")
                            }
                            HStack {
                                Text("💄")
                                Text("Get personalized beauty recommendations")
                            }
                            HStack {
                                Text("✨")
                                Text("Glow up based on your vibe!")
                            }
                        }
                        .foregroundColor(.white.opacity(0.9))
                        .font(.subheadline)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.white.opacity(0.2))
                    )
                    
                    Button(action: {
                        glowViewModel.startTeaSession()
                    }) {
                        HStack {
                            Image(systemName: "bubble.left.and.bubble.right.fill")
                                .foregroundColor(.pink)
                            Text("Start Spilling Tea! 🍵")
                                .fontWeight(.bold)
                                .foregroundColor(.pink)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(.white)
                                .shadow(color: .pink.opacity(0.3), radius: 10, x: 0, y: 5)
                        )
                    }
                }
                
                Spacer()
                
                // Logout Button
                Button(action: {
                    authManager.logout()
                }) {
                    Text("Logout")
                        .foregroundColor(.white.opacity(0.7))
                        .underline()
                }
            }
            .padding()
        }
    }
}

#Preview {
    DashboardHomeView()
}
