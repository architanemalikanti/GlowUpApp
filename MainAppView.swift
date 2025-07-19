
import SwiftUI

// MARK: - Main App View (handles authentication state)
struct MainAppView: View {
    @StateObject private var authManager = AuthManager()
    
    var body: some View {
        Group {
            if authManager.isAuthenticated { //basically if you're logged in, it shows dashboard view.
                DashboardView()
                    .environmentObject(authManager)
            } else {
                LoginView1()
                    .environmentObject(authManager)
            }
        }
    }
}
