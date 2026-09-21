import SwiftUI

@main
struct ThreeOneOSFiveApp: App {
    @StateObject private var appState = AppState()
    @AppStorage("hasAcceptedTerms") private var hasAcceptedTerms: Bool = false
    @AppStorage("selectedRole") private var selectedRoleRaw: String = ""
    @State private var roleGranted: Bool = false

    var body: some Scene {
        WindowGroup {
            Group {
                if !hasAcceptedTerms {
                    TermsView()
                } else if !roleGranted && selectedRoleRaw.isEmpty {
                    RoleGateView { role in
                        selectedRoleRaw = role.rawValue
                        roleGranted = true
                    }
                } else {
                    RootView()
                        .environmentObject(appState)
                        .environmentObject(appState.shimCheat)
                }
            }
            .onAppear {
                if !selectedRoleRaw.isEmpty { roleGranted = true }
                BackgroundMusic.shared.start()
            }
        }
    }
}