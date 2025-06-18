import SwiftUI


// MARK: - Dashboard View (shown after login)
struct DashboardView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.pink, Color.purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    VStack(spacing: 15) {
                        Image(systemName: "star.circle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.white)
                        
                        Text("Welcome back, \(authManager.currentUser?.username ?? "Glow Girl")! ✨")
                            .foregroundColor(.white)
                            .font(.title2)
                            .bold()
                            .multilineTextAlignment(.center)
                        
                        Text("You're logged in and glowing!")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.subheadline)
                    }
                    
                    VStack(spacing: 15) {
                        Text("Account Info:")
                            .foregroundColor(.white)
                            .font(.headline)
                        
                        if let user = authManager.currentUser {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Email: \(user.email)")
                                Text("Username: \(user.username)")
                                Text("Member since: \(user.createdAt.formatted(date: .abbreviated, time: .omitted))")
                            }
                            .foregroundColor(.white.opacity(0.9))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.white.opacity(0.2))
                            )
                        }
                    }
                    
                    Button(action: {
                        authManager.logout()
                    }) {
                        HStack {
                            Image(systemName: "arrow.left.heart.fill")
                                .foregroundColor(.pink)
                            Text("Logout")
                                .fontWeight(.semibold)
                                .foregroundColor(.pink)
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(.white)
                                .shadow(color: .pink.opacity(0.3), radius: 10, x: 0, y: 5)
                        )
                    }
                }
                .padding()
            }
        }
    }
}
