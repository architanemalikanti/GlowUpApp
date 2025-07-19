//
//  TeaChatView.swift
//  GlowGirl
//
//  Created by Archita Nemalikanti on 6/23/25.
//

import SwiftUI

// MARK: - Tea Chat View
struct TeaChatView: View {
    @EnvironmentObject var glowViewModel: GlowGirlViewModel
    @State private var messageText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Timer Header
            VStack(spacing: 5) {
                Text("Spill the Tea Time! 🍵")
                    .font(.headline)
                    .foregroundColor(.pink)
                
                Text(timeString(from: glowViewModel.timeRemaining))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(glowViewModel.timeRemaining < 60 ? .red : .purple)
            }
            .padding()
            .background(.white)
            .shadow(radius: 2)
            
            // Chat Messages
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(glowViewModel.chatMessages) { message in
                        MessageBubble(message: message)
                    }
                }
                .padding()
            }
            .background(
                LinearGradient(
                    colors: [Color.pink.opacity(0.1), Color.purple.opacity(0.1)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            // Message Input
            HStack(spacing: 10) {
                TextField("Spill the tea...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    if !messageText.isEmpty {
                        Task {
                            await glowViewModel.sendMessage(messageText)
                            messageText = ""
                        }
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Circle().fill(.pink))
                }
                .disabled(messageText.isEmpty || !glowViewModel.isTimerRunning)
            }
            .padding()
            .background(.white)
        }
    }
    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}


#Preview {
    TeaChatView()
}
