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
            .preferredColorScheme(.dark)
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
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer().frame(height: 72)
                Image(systemName: "crown.fill")
                    .font(.system(size: 52))
                    .foregroundStyle(.white)
                Text("SHINN CHEAT")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundStyle(.white)
                    .padding(.top, 18)
                Text("Điều khoản sử dụng")
                    .font(.subheadline)
                    .foregroundStyle(Color.white.opacity(0.45))
                    .padding(.top, 8)
                    .padding(.bottom, 28)

                Text("Shinn dùng để quản lý gói, tệp và cấu hình trên thiết bị của bạn. Tiếp tục nghĩa là bạn đã đọc và đồng ý.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.white.opacity(0.55))
                    .padding(.horizontal, 28)

                Spacer()

                Button {
                    hasAcceptedTerms = true
                } label: {
                    Text("Tôi đồng ý và tiếp tục")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .foregroundStyle(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
    }
}