//
//  ContentView.swift
//  GlowGirl
//
//  Created by Archita Nemalikanti on 6/17/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.pink, Color.purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    VStack(spacing: 20) {
                        Image(systemName: "sparkles")
                            .imageScale(.large)
                            .foregroundStyle(.white)
                        Text("welcome to glow!")
                            .foregroundColor(.white)
                            .font(.title2)
                            .bold()
                    }
                    
                    // Cute pink girly button
                    NavigationLink(destination: LoginView()) {
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.pink)
                            Text("start your glow up journey")
                                .fontWeight(.semibold)
                                .foregroundColor(.pink)
                            Image(systemName: "arrow.right.heart.fill")
                                .foregroundColor(.pink)
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(.white)
                                .shadow(color: .pink.opacity(0.3), radius: 10, x: 0, y: 5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(
                                    LinearGradient(
                                        colors: [.pink.opacity(0.5), .purple.opacity(0.3)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                        .scaleEffect(1.0)
                        .animation(.easeInOut(duration: 0.1), value: false)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .onTapGesture {
                        // Optional: Add haptic feedback
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                    }
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
