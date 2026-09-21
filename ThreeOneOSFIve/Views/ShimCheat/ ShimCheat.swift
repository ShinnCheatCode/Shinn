import SwiftUI

struct ShimCheatRootView: View {
    @EnvironmentObject var shimState: ShimCheatState
    @State private var route: ShimCheatRoute = .home

    var body: some View {
        NavigationStack {
            Group {
                switch route {
                case .home:      ShimCheatHomeView()
                case .games:     ShimCheatGamesView()
                case .tools:     ShimCheatToolsView()
                case .settings:  ShimCheatSettingsView()
                }
            }
            .navigationTitle(route.title)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button("Trang chủ") { route = .home }
                        Button("Trò chơi")  { route = .games }
                        Button("Công cụ")   { route = .tools }
                        Button("Cài đặt")   { route = .settings }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }
            }
        }
    }
}

enum ShimCheatRoute: Hashable {
    case home, games, tools, settings
    var title: String {
        switch self {
        case .home:     return "ShimCheat"
        case .games:    return "Trò chơi"
        case .tools:    return "Công cụ"
        case .settings: return "Cài đặt"
        }
    }
}

struct ShimCheatHomeView: View {
    @EnvironmentObject var shimState: ShimCheatState
    var body: some View {
        List {
            Section("Trạng thái") {
                HStack {
                    Text("Đã kích hoạt")
                    Spacer()
                    StatusBadge(text: shimState.isActive ? "BẬT" : "TẮT",
                                color: shimState.isActive ? .green : .gray)
                }
                Text("Phiên bản: \(shimState.version)")
                    .font(.caption).foregroundStyle(.secondary)
            }
            Section("Công tắc tổng") {
                Toggle("Kích hoạt ShimCheat", isOn: $shimState.isActive)
            }
            Section("Tích hợp 3105") {
                HStack {
                    Text("ContainerManager")
                    Spacer()
                    StatusBadge(text: "Sẵn sàng", color: .green)
                }
                HStack {
                    Text("Patch Engine")
                    Spacer()
                    StatusBadge(text: "Sẵn sàng", color: .green)
                }
            }
        }
    }
}

struct ShimCheatGamesView: View {
    @EnvironmentObject var shimState: ShimCheatState
    var body: some View {
        List {
            ForEach($shimState.games) { $game in
                HStack {
                    Image(systemName: "gamecontroller")
                    VStack(alignment: .leading, spacing: 2) {
                        Text(game.name)
                        Text(game.bundleID).font(.caption2).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Toggle("", isOn: $game.enabled).labelsHidden()
                }
            }
        }
    }
}

struct ShimCheatToolsView: View {
    @EnvironmentObject var shimState: ShimCheatState
    var body: some View {
        List {
            Section("Dữ liệu") {
                Button("Sao lưu")   { shimState.backup() }
                Button("Khôi phục") { shimState.restore() }
            }
            Section("Tệp cấu hình") {
                ForEach(shimState.configFiles) { file in
                    HStack {
                        Image(systemName: "doc.text")
                        Text(file.name)
                        Spacer()
                        if file.modified {
                            StatusBadge(text: "Đã sửa", color: .orange)
                        }
                    }
                }
            }
        }
    }
}

struct ShimCheatSettingsView: View {
    @EnvironmentObject var shimState: ShimCheatState
    var body: some View {
        Form {
            Section("Hiển thị") {
                Toggle("Hiện icon trên Home", isOn: $shimState.showIcon)
                Toggle("Ghi log hoạt động", isOn: $shimState.logEnabled)
            }
            Section("Bảo mật") {
                SecureField("Mật khẩu patch", text: $shimState.patchPassword)
            }
            Section("Khôi phục") {
                Button("Gỡ mọi thay đổi", role: .destructive) {
                    shimState.clearAll()
                }
            }
        }
    }
}