import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    DashboardHeader()
                    WelcomeBanner(userName: "Shinn", status: .connected)
                    SectionTitle(icon: "person.2.fill",
                                 title: "Chọn vai trò đăng nhập")
                    RoleGrid()
                    HStack {
                        SectionTitle(icon: "wrench.and.screwdriver.fill",
                                     title: "Free Fire Tools")
                        Spacer()
                        NavigationLink("All Tools Free") { ToolsGridView() }
                            .font(.caption)
                    }
                    ToolsGrid()
                    DashboardFooter()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .background(Color(red: 0.05, green: 0.07, blue: 0.15).ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}

struct DashboardHeader: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "crown.fill").font(.title).foregroundStyle(.purple)
            VStack(alignment: .leading, spacing: 2) {
                Text("Shinn Cheat").font(.title2.bold())
                Text("v2.0").font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            NavigationLink { SettingsView() } label: {
                Image(systemName: "gearshape.fill")
                    .padding(10).background(.ultraThinMaterial).clipShape(Circle())
            }
        }
        .padding(.top, 8)
    }
}

struct WelcomeBanner: View {
    let userName: String
    let status: DeviceStatus

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(colors: [.purple.opacity(0.6), .blue.opacity(0.4)],
                                     startPoint: .topLeading, endPoint: .bottomTrailing))
            HStack(spacing: 16) {
                ZStack(alignment: .bottomTrailing) {
                    Image("Avatar").resizable().scaledToFill()
                        .frame(width: 56, height: 56).clipShape(Circle())
                        .overlay(Circle().stroke(.white.opacity(0.4), lineWidth: 2))
                    Circle().fill(status.color).frame(width: 12, height: 12)
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text("Welcome, \(userName)").font(.headline)
                    Text("Device Status:").font(.caption)
                    Text(status.label).font(.caption.bold()).foregroundStyle(status.color)
                }
                Spacer()
                Text("Better Tools\nFor Your Game")
                    .font(.caption2).multilineTextAlignment(.trailing)
            }
            .padding(16)
        }
        .frame(height: 140)
    }
}

enum DeviceStatus {
    case connected, disconnected
    var label: String {
        switch self {
        case .connected: return "Connected"
        case .disconnected: return "Disconnected"
        }
    }
    var color: Color {
        switch self {
        case .connected: return .green
        case .disconnected: return .red
        }
    }
}

struct RoleGrid: View {
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            RoleCard(icon: "crown.fill", title: "Owner", subtitle: "Quyền cao nhất", color: .purple)
            RoleCard(icon: "checkmark.shield.fill", title: "Admin", subtitle: "Quản lý hệ thống", color: .blue)
            RoleCard(icon: "headphones", title: "Support", subtitle: "Hỗ trợ người dùng", color: .green)
            RoleCard(icon: "person.3.fill", title: "Member", subtitle: "Thành viên", color: .pink)
        }
    }
}

struct RoleCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    var body: some View {
        NavigationLink { RoleDetailView(title: title) } label: {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: icon).font(.title2).foregroundStyle(color)
                Text(title).font(.headline)
                Text(subtitle).font(.caption).foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14).background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}

struct ToolsGrid: View {
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ToolCard(icon: "folder.fill", title: "File Manager", subtitle: "Quản lý file dễ dàng", color: .blue)
            ToolCard(icon: "iphone", title: "Device Info", subtitle: "Thông tin thiết bị", color: .purple)
            ToolCard(icon: "number", title: "SHA-256", subtitle: "Kiểm tra file an toàn", color: .green)
            ToolCard(icon: "icloud.and.arrow.down", title: "Updates", subtitle: "Cập nhật phiên bản", color: .purple)
        }
    }
}

struct ToolCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    var body: some View {
        NavigationLink { ToolsGridView() } label: {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: icon).font(.title2).foregroundStyle(color)
                Text(title).font(.headline)
                Text(subtitle).font(.caption).foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14).background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}

struct DashboardFooter: View {
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: "heart.fill").foregroundStyle(.pink)
                Text("Free · Community Edition").font(.caption)
            }
            Text("3105Shinn").font(.caption2).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity).padding(.top, 12)
    }
}

struct ToolsGridView: View {
    var body: some View {
        List {
            Text("File Manager")
            Text("Device Info")
            Text("SHA-256")
            Text("Updates")
        }
        .navigationTitle("All Tools")
    }
}

struct RoleDetailView: View {
    let title: String
    var body: some View {
        List {
            Text("Vai trò: \(title)")
            Text("Chưa triển khai logic vai trò.").foregroundStyle(.secondary)
        }
        .navigationTitle(title)
    }
}

struct SupportButton: View {
    private let tgURL = "tg://resolve?domain=ShinnThieuu"
    private let webURL = "https://t.me/ShinnThieuu"
    var body: some View {
        Button {
            if let tg = URL(string: tgURL), UIApplication.shared.canOpenURL(tg) {
                UIApplication.shared.open(tg)
            } else if let web = URL(string: webURL) {
                UIApplication.shared.open(web)
            }
        } label: {
            HStack {
                Image(systemName: "questionmark.circle.fill")
                Text("Hỗ trợ trực tiếp")
                Spacer()
                Image(systemName: "arrow.up.right")
            }
            .padding().background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}