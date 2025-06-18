
import SwiftUI
import Foundation

// MARK: - User Model
struct User: Codable {
    let id: String
    let email: String
    let username: String
    let createdAt: Date
}

// MARK: - Authentication Manager
class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let userDefaults = UserDefaults.standard
    private let authTokenKey = "auth_token"
    private let userDataKey = "user_data"
    
    init() {
        checkAuthStatus()
    }
    
    // Check if user is already logged in
    func checkAuthStatus() {
        if let token = userDefaults.string(forKey: authTokenKey),
           let userData = userDefaults.data(forKey: userDataKey),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            self.isAuthenticated = true
            self.currentUser = user
        }
    }
    
    // MARK: - Sign Up
    func signUp(email: String, username: String, password: String) async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        // Simulate API call delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Basic validation
        guard isValidEmail(email) else {
            await MainActor.run {
                errorMessage = "Please enter a valid email address"
                isLoading = false
            }
            return
        }
        
        guard username.count >= 3 else {
            await MainActor.run {
                errorMessage = "Username must be at least 3 characters"
                isLoading = false
            }
            return
        }
        
        guard password.count >= 6 else {
            await MainActor.run {
                errorMessage = "Password must be at least 6 characters"
                isLoading = false
            }
            return
        }
        
        // Check if user already exists (simulate)
        if await userExists(email: email) {
            await MainActor.run {
                errorMessage = "An account with this email already exists"
                isLoading = false
            }
            return
        }
        
        // Create new user
        let newUser = User(
            id: UUID().uuidString,
            email: email,
            username: username,
            createdAt: Date()
        )
        
        // Simulate successful registration
        let authToken = "auth_token_\(UUID().uuidString)"
        
        await MainActor.run {
            saveUserSession(user: newUser, token: authToken)
            isLoading = false
        }
    }
    
    // MARK: - Login
    func login(email: String, password: String) async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        // Simulate API call delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Basic validation
        guard isValidEmail(email) else {
            await MainActor.run {
                errorMessage = "Please enter a valid email address"
                isLoading = false
            }
            return
        }
        
        guard !password.isEmpty else {
            await MainActor.run {
                errorMessage = "Please enter your password"
                isLoading = false
            }
            return
        }
        
        // Simulate authentication check
        if let storedUser = await getStoredUser(email: email) {
            // Simulate successful login - in real app, you'd verify password with server
            let authToken = "auth_token_\(UUID().uuidString)"
            
            await MainActor.run {
                saveUserSession(user: storedUser, token: authToken)
                isLoading = false
            }
        } else {
            await MainActor.run {
                errorMessage = "Invalid email or password"
                isLoading = false
            }
        }
    }
    
    // MARK: - Logout
    func logout() {
        userDefaults.removeObject(forKey: authTokenKey)
        userDefaults.removeObject(forKey: userDataKey)
        
        isAuthenticated = false
        currentUser = nil
        errorMessage = nil
    }
    
    // MARK: - Private Helper Methods
    private func saveUserSession(user: User, token: String) {
        userDefaults.set(token, forKey: authTokenKey)
        
        if let userData = try? JSONEncoder().encode(user) {
            userDefaults.set(userData, forKey: userDataKey)
        }
        
        self.currentUser = user
        self.isAuthenticated = true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // Simulate checking if user exists (in real app, this would be an API call)
    private func userExists(email: String) async -> Bool {
        // For demo purposes, let's say admin@test.com already exists
        return email.lowercased() == "admin@test.com"
    }
    
    // Simulate getting stored user (in real app, this would be an API call)
    private func getStoredUser(email: String) async -> User? {
        // For demo purposes, create a mock user for testing
        if email.lowercased() == "test@test.com" {
            return User(
                id: "test_user_id",
                email: email,
                username: "TestUser",
                createdAt: Date()
            )
        }
        return nil
    }
}
