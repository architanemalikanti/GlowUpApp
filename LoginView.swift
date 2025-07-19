// MARK: - Updated Login Page View

import SwiftUI
struct LoginView: View {
    @StateObject private var authManager = AuthManager()
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var isLogin = true
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.purple, Color.pink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 15) {
                        Image(systemName: isLogin ? "star.fill" : "sparkles")
                            .font(.system(size: 40))
                            .foregroundStyle(.white)
                        
                        Text(isLogin ? "Welcome Back! 💖" : "Join the Glow! ✨")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .bold()
                        
                        Text(isLogin ? "Ready to glow again?" : "Let's get you started!")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.subheadline)
                    }
                    .padding(.top, 40)
                    
                    // Error Message
                    if let errorMessage = authManager.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.red.opacity(0.3))
                            )
                            .padding(.horizontal, 20)
                    }
                    
                    // Form Container
                    VStack(spacing: 20) {
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.pink)
                                Text("Email")
                                    .foregroundColor(.pink)
                                    .fontWeight(.semibold)
                            }
                            
                            TextField("your.email@example.com", text: $email)
                                .textFieldStyle(GirlyTextFieldStyle())
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        
                        // Username Field (only for signup)
                        if !isLogin {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.pink)
                                    Text("Username")
                                        .foregroundColor(.pink)
                                        .fontWeight(.semibold)
                                }
                                
                                TextField("Choose a cute username", text: $username)
                                    .textFieldStyle(GirlyTextFieldStyle())
                                    .autocapitalization(.none)
                            }
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.pink)
                                Text("Password")
                                    .foregroundColor(.pink)
                                    .fontWeight(.semibold)
                            }
                            
                            SecureField("Enter your password", text: $password)
                                .textFieldStyle(GirlyTextFieldStyle())
                        }
                        
                        // Demo Instructions
                        VStack(alignment: .leading, spacing: 5) {
                            Text("For demo purposes:")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            Text("• Login: test@test.com + any password")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            Text("• Signup: any email except admin@test.com")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white.opacity(0.1))
                        )
                        
                        // Main Action Button
                        Button(action: {
                            Task {
                                if isLogin {
                                    await authManager.login(email: email, password: password)
                                } else {
                                    await authManager.signUp(email: email, username: username, password: password)
                                }
                            }
                        }) {
                            HStack {
                                if authManager.isLoading {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                        .progressViewStyle(CircularProgressViewStyle(tint: .pink))
                                } else {
                                    Image(systemName: isLogin ? "arrow.right.heart.fill" : "star.fill")
                                        .foregroundColor(.pink)
                                    Text(isLogin ? "Let's Glow!" : "Start Glowing!")
                                        .fontWeight(.bold)
                                        .foregroundColor(.pink)
                                    Image(systemName: "sparkles")
                                        .foregroundColor(.pink)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
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
                        }
                        .disabled(authManager.isLoading)
                        .padding(.top, 10)
                        
                        // Toggle between login/signup
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isLogin.toggle()
                                authManager.errorMessage = nil
                                email = ""
                                username = ""
                                password = ""
                            }
                        }) {
                            HStack {
                                Text(isLogin ? "New here?" : "Already have an account?")
                                    .foregroundColor(.white.opacity(0.8))
                                Text(isLogin ? "Join the glow!" : "Welcome back!")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                    .underline()
                            }
                        }
                        .disabled(authManager.isLoading)
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 40)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.white.opacity(0.15))
                            .background(.ultraThinMaterial)
                    )
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 50)
                }
            }
        }
    }
}
// Custom text field style (same as before)
struct GirlyTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .shadow(color: .pink.opacity(0.2), radius: 5, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.pink.opacity(0.3), lineWidth: 1)
            )
            .foregroundColor(.pink)
    }
}
