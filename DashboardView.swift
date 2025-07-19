import SwiftUI


// MARK: - Main Dashboard (Updated)
struct DashboardView: View {
    @EnvironmentObject var authManager: AuthManager
    @StateObject private var glowViewModel = GlowGirlViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                switch glowViewModel.currentState {
                case .dashboard:
                    DashboardHomeView()
                case .chatting:
                    TeaChatView()
                case .analyzing:
                    AnalyzingView()
                case .recommendations:
                    RecommendationsView()
                }
            }
            .environmentObject(glowViewModel)
        }
    }
}
    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            return displayFormatter.string(from: date)
        }
        return "N/A"
    }

