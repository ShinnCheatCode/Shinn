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

struct TermsView: View {
    @AppStorage("hasAcceptedTerms") private var hasAcceptedTerms = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Điều khoản sử dụng")
                    .font(.title.bold())
                Text("Shinn 2.0 dùng để quản lý gói, tệp và cấu hình trên thiết bị của bạn. Tiếp tục nghĩa là bạn đã đọc và đồng ý.")
                    .foregroundStyle(.secondary)
                Button {
                    hasAcceptedTerms = true
                } label: {
                    Text("Tôi đồng ý và tiếp tục")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(24)
        }
    }
}