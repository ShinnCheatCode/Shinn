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
            .background(Color(red: 0.04, green: 0.06, blue: 0.14).ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}

struct DashboardHeader: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "crown.fill")
                .font(.system(size: 30))
                .foregroundStyle(
                    LinearGradient(colors: [.purple, .blue],
                                   startPoint: .top, endPoint: .bottom)
                )
            VStack(alignment: .leading, spacing: 2) {
                Text("Shinn Cheat")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                Text("v2.0")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            Spacer()
            NavigationLink { SettingsView() } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(.blue)
                    .padding(10)
                    .background(Color.white.opacity(0.08))
                    .clipShape(Circle())
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
            RoundedRectangle(cornerRadius: 18)
                .fill(LinearGradient(
                    colors: [Color.purple.opacity(0.85),
                             Color.blue.opacity(0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))

            HStack(spacing: 16) {
                ZStack(alignment: .bottomTrailing) {
                    Image("Avatar")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.white.opacity(0.5), lineWidth: 2))
                    Circle()
                        .fill(status.color)
                        .frame(width: 14, height: 14)
                        .overlay(Circle().stroke(.white, lineWidth: 2))
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Welcome,")
                        .font(.headline)
                        .foregroundStyle(.white)
                    Text(userName)
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                    Text("Device Status:")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                    Text(status.label)
                        .font(.caption.bold())
                        .foregroundStyle(status.color)
                }
                Spacer()
                Text("Better Tools\nFor Your\nGame")
                    .font(.caption)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.trailing)
            }
            .padding(18)
        }
        .frame(height: 150)
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
            RoleCard(icon: "crown.fill", title: "Owner",
                     subtitle: "Quyền cao nhất", color: .purple)
            RoleCard(icon: "checkmark.shield.fill", title: "Admin",
                     subtitle: "Quản lý hệ thống", color: .blue)
            RoleCard(icon: "headphones", title: "Support",
                     subtitle: "Hỗ trợ người dùng", color: .green)
            RoleCard(icon: "person.3.fill", title: "Member",
                     subtitle: "Thành viên", color: .pink)
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
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(Color.white.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
        }
    }
}

struct ToolsGrid: View {
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ToolCard(icon: "folder.fill", title: "File Manager",
                     subtitle: "Quản lý file dễ dàng", color: .blue)
            ToolCard(icon: "iphone", title: "Device Info",
                     subtitle: "Thông tin thiết bị", color: .purple)
            ToolCard(icon: "number", title: "SHA-256",
                     subtitle: "Kiểm tra file an toàn", color: .green)
            ToolCard(icon: "icloud.and.arrow.down", title: "Updates",
                     subtitle: "Cập nhật phiên bản", color: .purple)
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
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(Color.white.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
        }
    }
}

struct DashboardFooter: View {
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: "heart.fill").foregroundStyle(.pink)
                Text("Free · Community Edition")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
            }
            Text("3105Shinn")
                .font(.caption2)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 12)
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
            Text("Chưa triển khai logic vai trò.")
                .foregroundStyle(.secondary)
        }
        .navigationTitle(title)
    }
}