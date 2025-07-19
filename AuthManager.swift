import SwiftUI
import Foundation

// MARK: - User Model
struct User: Codable {
    let id: Int
    let email: String
    let username: String
    let created_at: String // Changed to String to match backend ISO format
    
    // Helper to convert created_at string to Date
    var createdAtDate: Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: created_at)
    }
}

// MARK: - API Response Models
struct AuthResponse: Codable {
    let message: String
    let token: String
    let user: User
}

struct ErrorResponse: Codable {
    let error: String
}

// MARK: - API Service
class APIService {
    static let shared = APIService()
    private let baseURL = "http://10.250.198.173:5001" // Change this to your server IP
    
    private init() {}
    
    func register(email: String, username: String, password: String) async throws -> AuthResponse {
        let url = URL(string: "\(baseURL)/api/auth/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = [
            "email": email,
            "username": username,
            "password": password
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Add debugging
        print("Response status: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
        print("Response data: \(String(data: data, encoding: .utf8) ?? "No data")")
        
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 201 {
                do {
                    return try JSONDecoder().decode(AuthResponse.self, from: data)
                } catch {
                    print("Decoding error: \(error)")
                    throw APIError.decodingError
                }
            } else {
                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                throw APIError.serverError(errorResponse.error)
            }
        }
        
        throw APIError.networkError
    }
    
    func login(email: String, password: String) async throws -> AuthResponse {
        let url = URL(string: "\(baseURL)/auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = [
            "email": email,
            "password": password
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                return try JSONDecoder().decode(AuthResponse.self, from: data)
            } else {
                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                throw APIError.serverError(errorResponse.error)
            }
        }
        
        throw APIError.networkError
    }
    
    func getCurrentUser(token: String) async throws -> User {
        let url = URL(string: "\(baseURL)/auth/me")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                let userResponse = try JSONDecoder().decode([String: User].self, from: data)
                return userResponse["user"]!
            } else {
                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                throw APIError.serverError(errorResponse.error)
            }
        }
        
        throw APIError.networkError
    }
}

// MARK: - API Errors
enum APIError: Error, LocalizedError {
    case networkError
    case serverError(String)
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "Network connection failed"
        case .serverError(let message):
            return message
        case .decodingError:
            return "Failed to process server response"
        }
    }
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
            
            // Verify token is still valid by fetching current user
            Task {
                do {
                    let currentUser = try await APIService.shared.getCurrentUser(token: token)
                    await MainActor.run {
                        self.currentUser = currentUser
                        self.isAuthenticated = true
                    }
                } catch {
                    // Token is invalid, clear stored data
                    await MainActor.run {
                        self.logout()
                    }
                }
            }
        }
    }
    
    // MARK: - Sign Up
    func signUp(email: String, username: String, password: String) async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            let response = try await APIService.shared.register(
                email: email,
                username: username,
                password: password
            )
            
            await MainActor.run {
                saveUserSession(user: response.user, token: response.token)
                isLoading = false
            }
            
        } catch let error as APIError {
            await MainActor.run {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        } catch {
            await MainActor.run {
                print("Registration error: \(error)") // Add this line for debugging
                errorMessage = "Registration failed. Please try again."
                isLoading = false
            }
        }
    }
    
    // MARK: - Login
    func login(email: String, password: String) async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            let response = try await APIService.shared.login(
                email: email,
                password: password
            )
            
            await MainActor.run {
                saveUserSession(user: response.user, token: response.token)
                isLoading = false
            }
            
        } catch let error as APIError {
            await MainActor.run {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        } catch {
            await MainActor.run {
                errorMessage = "Login failed. Please try again."
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
    
    // Get stored token for making authenticated requests
    func getAuthToken() -> String? {
        return userDefaults.string(forKey: authTokenKey)
    }
}
