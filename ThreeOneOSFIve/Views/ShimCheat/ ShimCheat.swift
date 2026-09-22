import SwiftUI
import Combine
import Foundation
import CryptoKit
import UIKit

@main
struct ShinnApp: App {
    @StateObject private var store = AppStore()
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
                .preferredColorScheme(.dark)
                .tint(Ink.steel)
        }
    }
}

enum Ink {
    static let bg = Color(red: 0.043, green: 0.047, blue: 0.055)
    static let panel = Color(red: 0.078, green: 0.086, blue: 0.098)
    static let line = Color(red: 0.18, green: 0.20, blue: 0.23)
    static let steel = Color(red: 0.773, green: 0.804, blue: 0.839)
    static let mute = Color(red: 0.55, green: 0.58, blue: 0.62)
    static let ok = Color(red: 0.55, green: 0.78, blue: 0.62)
    static let warn = Color(red: 0.90, green: 0.62, blue: 0.38)
}

struct Monogram: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Ink.steel, lineWidth: 1.4)
            Text("S")
                .font(.system(size: 16, weight: .semibold, design: .serif))
                .foregroundStyle(Ink.steel)
        }
        .frame(width: 32, height: 32)
        .accessibilityHidden(true)
    }
}

struct Surface<Content: View>: View {
    var content: () -> Content
    var body: some View {
        VStack(alignment: .leading, spacing: 12, content: content)
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Ink.panel, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(Ink.line, lineWidth: 1))
    }
}

struct PageHead: View {
    let title: String
    var subtitle: String? = nil
    var back: (() -> Void)? = nil
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if let back {
                Button(action: back) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(width: 40, height: 40)
                        .background(Ink.panel, in: Circle())
                        .overlay(Circle().stroke(Ink.line, lineWidth: 1))
                }
                .accessibilityLabel("Quay lại")
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.system(size: 22, weight: .semibold)).tracking(-0.4)
                if let subtitle {
                    Text(subtitle).font(.system(size: 13)).foregroundStyle(Ink.mute)
                }
            }
            Spacer(minLength: 0)
        }
        .foregroundStyle(Ink.steel)
        .padding(.bottom, 8)
    }
}

enum Role: String, Codable, CaseIterable, Identifiable {
    case owner, admin, support, member
    var id: String { rawValue }
    var title: String {
        switch self {
        case .owner: return "Owner"
        case .admin: return "Admin"
        case .support: return "Support"
        case .member: return "Member"
        }
    }
    var subtitle: String {
        switch self {
        case .owner: return "Quyền cao nhất"
        case .admin: return "Quản lý hệ thống"
        case .support: return "Hỗ trợ người dùng"
        case .member: return "Thành viên"
        }
    }
}

enum TabID: String, CaseIterable, Identifiable {
    case home, sources, installed, files, more
    var id: String { rawValue }
    var title: String {
        switch self {
        case .home: return "Trang chủ"
        case .sources: return "Nguồn"
        case .installed: return "Đã cài"
        case .files: return "Tệp"
        case .more: return "Thêm"
        }
    }
    var symbol: String {
        switch self {
        case .home: return "house.fill"
        case .sources: return "shippingbox"
        case .installed: return "square.stack.3d.up"
        case .files: return "folder"
        case .more: return "ellipsis"
        }
    }
}

enum FileArea: String, Codable, CaseIterable, Identifiable {
    case workspace, application, appGroup
    var id: String { rawValue }
    var title: String {
        switch self {
        case .workspace: return "Workspace"
        case .application: return "Application"
        case .appGroup: return "App Group"
        }
    }
}

enum PackageType: String, Codable { case patch, wallpaper, tool, feature }

enum ToolID: String, Codable, CaseIterable, Identifiable {
    case files, device, hash, updates, cleaner, wallpaper, patches, shim
    var id: String { rawValue }
    var title: String {
        switch self {
        case .files: return "Quản lý tệp"
        case .device: return "Thông tin thiết bị"
        case .hash: return "SHA-256"
        case .updates: return "Cập nhật"
        case .cleaner: return "Dọn dẹp"
        case .wallpaper: return "Hình nền"
        case .patches: return "Patch"
        case .shim: return "Lớp cấu hình"
        }
    }
    var subtitle: String {
        switch self {
        case .files: return "Duyệt, gắn sao, đo dung lượng"
        case .device: return "Bundle, bản dựng, môi trường"
        case .hash: return "Băm tệp để đối chiếu"
        case .updates: return "Phiên bản gói và ứng dụng"
        case .cleaner: return "Quét cache sandbox"
        case .wallpaper: return "Gói giao diện Ink"
        case .patches: return "Áp dụng và khôi phục"
        case .shim: return "Công tắc và tệp cấu hình"
        }
    }
    var symbol: String {
        switch self {
        case .files: return "folder"
        case .device: return "iphone"
        case .hash: return "number"
        case .updates: return "arrow.triangle.2.circlepath"
        case .cleaner: return "trash"
        case .wallpaper: return "paintbrush"
        case .patches: return "puzzlepiece"
        case .shim: return "square.stack.3d.up"
        }
    }
}

struct SourceItem: Codable, Identifiable, Hashable {
    var id, name, url: String
    var isDefault, enabled: Bool
}
struct CatalogPackage: Codable, Identifiable, Hashable {
    var id: String { identifier }
    var identifier, name, author, version, summary, description, category: String
    var tags: [String]; var publishedAt, sha256: String
    var size: Int; var featured: Bool; var icon: String; var type: PackageType
}
struct InstalledItem: Codable, Identifiable, Hashable {
    var id, name, icon: String; var type: PackageType
    var version: String; var hasUpdate: Bool; var installedAt: String; var packageId: String?
}
struct FileEntry: Codable, Identifiable, Hashable {
    var id, name, path: String; var area: FileArea; var isDirectory: Bool
    var size: Int; var content: String; var isFavorite, hidden: Bool
    var sha256, modifiedAt: String
}
struct PatchRule: Codable, Identifiable, Hashable { var id, path, action, payload: String }
struct PatchItem: Codable, Identifiable, Hashable {
    var id, name, version, author, summary: String
    var targets: [String]; var rules: [PatchRule]; var isApplied: Bool
}
struct ShimGame: Codable, Identifiable, Hashable { var id, name, bundleID: String; var enabled: Bool }
struct ShimConfigFile: Codable, Identifiable, Hashable { var id, name: String; var modified: Bool }
struct CleanerItem: Codable, Identifiable, Hashable { var id, path: String; var size: Int; var kind: String }
struct WallpaperPack: Codable, Identifiable, Hashable { var id, name, tone: String; var installed: Bool }
struct LogEntry: Codable, Identifiable, Hashable { var id, at, message: String }
enum Route: Hashable {
    case home, sources, installed, files, more
    case tool(ToolID), package(String), patch(String), source(String), about, logs
}
struct TargetApp: Identifiable { var id: String { bundleID }; var bundleID, name: String }
enum AppMeta {
    static let version = "2.0", build = "1", defaultPassword = "080109"
    static let targets: [TargetApp] = [
        .init(bundleID: "com.dts.freefiremax", name: "Free Fire MAX"),
        .init(bundleID: "com.dts.freefireth", name: "Free Fire"),
        .init(bundleID: "com.garena.game.kgvn", name: "Liên Quân Mobile"),
    ]
}
enum Perm { case sources, reset, password, patch, install, uninstall, clean, shim }
extension Route {
    static func from(tab: TabID) -> Route {
        switch tab {
        case .home: return .home
        case .sources: return .sources
        case .installed: return .installed
        case .files: return .files
        case .more: return .more
        }
    }
}

enum Catalog {
    static let defaultSource = SourceItem(id: "com.shinn.lab", name: "Shinn Lab", url: "local://shinn-lab", isDefault: true, enabled: true)
    static let packages: [CatalogPackage] = [
        .init(identifier: "com.shinn.files.pro", name: "Quản lý tệp Pro", author: "Shinn", version: "2.0", summary: "Duyệt workspace, Application và App Group", description: "Mở rộng trình duyệt tệp, gắn sao và SHA-256.", category: "Công cụ", tags: ["files"], publishedAt: "2026-09-12T00:00:00Z", sha256: "local-files-pro", size: 184320, featured: true, icon: "files", type: .tool),
        .init(identifier: "com.shinn.device.report", name: "Báo cáo thiết bị", author: "Shinn", version: "2.0", summary: "Bundle, bản dựng, môi trường", description: "Đọc thông tin nhận dạng app.", category: "Công cụ", tags: ["device"], publishedAt: "2026-09-10T00:00:00Z", sha256: "local-device-report", size: 73728, featured: true, icon: "device", type: .feature),
        .init(identifier: "com.shinn.hash.kit", name: "Bộ kiểm SHA-256", author: "Shinn", version: "2.0", summary: "Băm tệp sandbox", description: "Tính SHA-256 và sao chép hex.", category: "Bảo mật", tags: ["sha256"], publishedAt: "2026-09-08T00:00:00Z", sha256: "local-hash-kit", size: 55296, featured: true, icon: "hash", type: .tool),
        .init(identifier: "com.shinn.wallpaper.ink", name: "Gói hình nền Ink", author: "Shinn", version: "1.4", summary: "Ba tông màu mực", description: "Midnight, Paper, Steel.", category: "Giao diện", tags: ["wallpaper"], publishedAt: "2026-09-01T00:00:00Z", sha256: "local-wallpaper-ink", size: 241664, featured: false, icon: "wallpaper", type: .wallpaper),
        .init(identifier: "com.shinn.cleaner.smart", name: "Dọn cache thông minh", author: "Shinn", version: "1.8", summary: "Quét cache sandbox", description: "Quét Logs, Caches, tmp.", category: "Hệ thống", tags: ["cleaner"], publishedAt: "2026-08-28T00:00:00Z", sha256: "local-cleaner", size: 98304, featured: false, icon: "cleaner", type: .tool),
        .init(identifier: "com.shinn.config.backup", name: "Sao lưu cấu hình", author: "Shinn", version: "1.2", summary: "Xuất snapshot JSON", description: "Sao lưu cấu hình cục bộ.", category: "Hệ thống", tags: ["backup"], publishedAt: "2026-08-20T00:00:00Z", sha256: "local-backup", size: 40960, featured: false, icon: "box", type: .feature),
        .init(identifier: "com.shinn.patch.cache", name: "Tối ưu cache", author: "Shinn", version: "1.0", summary: "Ghi cache-policy.json ảo", description: "Patch JSON trong sandbox.", category: "Patch", tags: ["patch"], publishedAt: "2026-09-15T00:00:00Z", sha256: "local-patch-cache", size: 16384, featured: true, icon: "patches", type: .patch),
        .init(identifier: "com.shinn.patch.logfilter", name: "Bộ lọc nhật ký", author: "Shinn", version: "1.1", summary: "Tắt verbose logging.plist", description: "Thay thế plist ảo.", category: "Patch", tags: ["patch"], publishedAt: "2026-09-14T00:00:00Z", sha256: "local-patch-log", size: 12288, featured: false, icon: "patches", type: .patch),
    ]
    static let files: [FileEntry] = [
        file("ws-patches", "Patches", "/workspace/Patches", .workspace, dir: true, fav: true),
        file("ws-cache-json", "cache-policy.json", "/workspace/Patches/cache-policy.json", .workspace, content: "{\n  \"ttl\": 3600,\n  \"maxEntries\": 256,\n  \"verbose\": true\n}\n"),
        file("ws-backup", "Backups", "/workspace/Backups", .workspace, dir: true),
        file("ws-hidden", ".shinn-lock", "/workspace/.shinn-lock", .workspace, content: "role-gate:v2\n", hidden: true),
        file("app-docs", "Documents", "/var/mobile/Containers/Data/Application/Documents", .application, dir: true),
        file("app-log-plist", "logging.plist", "/var/mobile/Containers/Data/Application/Library/logging.plist", .application, content: "{\n  \"Enabled\": true,\n  \"Level\": \"verbose\"\n}\n"),
        file("app-cache", "Cache.db", "/var/mobile/Containers/Data/Application/Library/Caches/Cache.db", .application, content: "cache-stub-shinn-2026"),
        file("app-tmp", "tmp", "/var/mobile/Containers/Data/Application/tmp", .application, dir: true),
        file("app-tmp-log", "session.log", "/var/mobile/Containers/Data/Application/tmp/session.log", .application, content: "boot ok\nrole=member\n"),
        file("grp-prefs", "group.plist", "/var/mobile/Containers/Shared/AppGroup/group.plist", .appGroup, content: "{\n  \"bundle\": \"com.shinn.console\",\n  \"channel\": \"community\"\n}\n", fav: true),
        file("grp-hidden", ".DS_Store", "/var/mobile/Containers/Shared/AppGroup/.DS_Store", .appGroup, content: "dsstore", hidden: true),
    ]
    static let patches: [PatchItem] = [
        .init(id: "cache-opt", name: "Tối ưu cache", version: "1.0", author: "Shinn", summary: "Ghi ttl/maxEntries vào cache-policy.json", targets: AppMeta.targets.map(\.bundleID), rules: [.init(id: "r1", path: "/workspace/Patches/cache-policy.json", action: "json", payload: "{\n  \"ttl\": 120,\n  \"maxEntries\": 64,\n  \"verbose\": false\n}\n")], isApplied: false),
        .init(id: "log-filter", name: "Bộ lọc nhật ký", version: "1.1", author: "Shinn", summary: "Tắt verbose trên logging.plist", targets: AppMeta.targets.map(\.bundleID), rules: [.init(id: "r2", path: "/var/mobile/Containers/Data/Application/Library/logging.plist", action: "plist", payload: "{\n  \"Enabled\": true,\n  \"Level\": \"error\"\n}\n")], isApplied: false),
    ]
    static let shimGames: [ShimGame] = AppMeta.targets.enumerated().map { .init(id: "g\($0.offset)", name: $0.element.name, bundleID: $0.element.bundleID, enabled: $0.offset == 0) }
    static let shimFiles: [ShimConfigFile] = [
        .init(id: "sf1", name: "cache-policy.json", modified: false),
        .init(id: "sf2", name: "logging.plist", modified: false),
        .init(id: "sf3", name: "group.plist", modified: false),
    ]
    static let wallpapers: [WallpaperPack] = [
        .init(id: "midnight", name: "Midnight", tone: "#0B0C0E", installed: false),
        .init(id: "paper", name: "Paper", tone: "#E8E4DC", installed: false),
        .init(id: "steel", name: "Steel", tone: "#C5CDD6", installed: false),
    ]
    static let cleaner: [CleanerItem] = [
        .init(id: "c1", path: "Library/Caches", size: 1_248_000, kind: "cache"),
        .init(id: "c2", path: "tmp", size: 86_000, kind: "tmp"),
        .init(id: "c3", path: "Library/Logs", size: 32_400, kind: "log"),
    ]
    static func sha256(_ text: String) -> String {
        SHA256.hash(data: Data(text.utf8)).map { String(format: "%02x", $0) }.joined()
    }
    static func hashed(_ files: [FileEntry]) -> [FileEntry] {
        files.map { f in
            var c = f
            if f.isDirectory { c.size = 0; c.sha256 = "" }
            else { c.size = f.content.utf8.count; c.sha256 = sha256(f.content) }
            return c
        }
    }
    private static func file(_ id: String, _ name: String, _ path: String, _ area: FileArea, dir: Bool = false, content: String = "", fav: Bool = false, hidden: Bool = false) -> FileEntry {
        .init(id: id, name: name, path: path, area: area, isDirectory: dir, size: 0, content: content, isFavorite: fav, hidden: hidden, sha256: "", modifiedAt: "2026-09-18T10:00:00Z")
    }
}

@MainActor
final class AppStore: ObservableObject {
    @Published var hasAcceptedTerms = false
    @Published var role: Role?
    @Published var passwords = (owner: AppMeta.defaultPassword, admin: AppMeta.defaultPassword)
    @Published var tab: TabID = .home
    @Published var route: Route = .home
    @Published var query = ""
    @Published var showHidden = false
    @Published var fileArea: FileArea = .workspace
    @Published var sources: [SourceItem] = [Catalog.defaultSource]
    @Published var installed: [InstalledItem] = []
    @Published var files: [FileEntry] = Catalog.hashed(Catalog.files)
    @Published var patches: [PatchItem] = Catalog.patches
    @Published var backups: [String: [String: String]] = [:]
    @Published var shimActive = false
    @Published var shimShowIcon = true
    @Published var shimLog = false
    @Published var shimGames: [ShimGame] = Catalog.shimGames
    @Published var shimFiles: [ShimConfigFile] = Catalog.shimFiles
    @Published var wallpapers: [WallpaperPack] = Catalog.wallpapers
    @Published var cleaner: [CleanerItem] = Catalog.cleaner
    @Published var selectedClean: Set<String> = []
    @Published var logs: [LogEntry] = []
    @Published var lastResult: String?
    @Published var toast: String?
    @Published var passwordDraft = ""
    @Published var passwordError = false
    @Published var pendingRole: Role?
    @Published var newSourceURL = ""
    @Published var hashHex = ""
    @Published var hashName = ""
    @Published var hashSize = 0
    @Published var installingId: String?
    private let persistKey = "shinn.ui.v1"
    init() { load() }

    func can(_ action: Perm) -> Bool {
        guard let role else { return false }
        switch action {
        case .sources, .password: return role == .owner || role == .admin
        case .reset: return role == .owner
        case .patch, .shim: return role != .member
        case .install: return true
        case .uninstall, .clean: return role == .owner || role == .admin
        }
    }
    func acceptTerms() { hasAcceptedTerms = true; persist() }
    func grant(_ role: Role, password: String) -> Bool {
        if role == .owner || role == .admin {
            let expected = role == .owner ? passwords.owner : passwords.admin
            guard password == expected else { passwordError = true; return false }
        }
        self.role = role; passwordDraft = ""; passwordError = false; pendingRole = nil
        go(.home); log("role:\(role.rawValue)"); persist(); return true
    }
    func signOut() { role = nil; go(.home); persist() }
    func go(_ route: Route) {
        self.route = route
        switch route {
        case .home: tab = .home
        case .sources: tab = .sources
        case .installed: tab = .installed
        case .files: tab = .files
        default: break
        }
        lastResult = nil
    }
    func setTab(_ tab: TabID) {
        self.tab = tab; query = ""
        switch tab {
        case .home: route = .home
        case .sources: route = .sources
        case .installed: route = .installed
        case .files: route = .files
        case .more: route = .more
        }
    }
    func back() {
        switch route {
        case .tool, .package, .patch, .source, .about, .logs: go(Route.from(tab: tab))
        default: break
        }
    }
    func allPackages() -> [CatalogPackage] { Catalog.packages }
    func install(_ id: String) {
        guard can(.install), installingId == nil else { return }
        guard let pkg = allPackages().first(where: { $0.identifier == id }) else { return }
        guard !installed.contains(where: { $0.packageId == id }) else { return }
        installingId = id
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            installed.append(.init(id: nid("ins"), name: pkg.name, icon: pkg.icon, type: pkg.type, version: pkg.version, hasUpdate: false, installedAt: ISO8601DateFormatter().string(from: Date()), packageId: pkg.identifier))
            installingId = nil; toast = "Đã cài"; log("install:\(pkg.name)"); persist()
        }
    }
    func uninstall(_ id: String) {
        guard can(.uninstall) else { flash("Vai trò hiện tại không đủ quyền"); return }
        installed.removeAll { $0.id == id }; persist()
    }
    func addSource() {
        guard can(.sources) else { flash("Vai trò hiện tại không đủ quyền"); return }
        let url = newSourceURL.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !url.isEmpty else { return }
        guard !sources.contains(where: { $0.url == url }) else { flash("Nguồn đã tồn tại"); return }
        let name = url.replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "http://", with: "")
        sources.append(.init(id: nid("src"), name: String(name.prefix(40)), url: url, isDefault: false, enabled: true))
        newSourceURL = ""; flash("Đã thêm nguồn"); persist()
    }
    func removeSource(_ id: String) {
        guard can(.sources) else { return }
        guard let src = sources.first(where: { $0.id == id }), !src.isDefault else { flash("Không xóa được nguồn mặc định"); return }
        sources.removeAll { $0.id == id }; persist()
    }
    func toggleFavorite(_ id: String) {
        if let i = files.firstIndex(where: { $0.id == id }) { files[i].isFavorite.toggle(); persist() }
    }
    func applyPatch(_ id: String) {
        guard can(.patch) else { flash("Vai trò hiện tại không đủ quyền"); return }
        guard let patch = patches.first(where: { $0.id == id }) else { return }
        var snap = backups[id] ?? [:]
        for rule in patch.rules {
            guard let i = files.firstIndex(where: { $0.path == rule.path && !$0.isDirectory }) else { continue }
            if snap[files[i].id] == nil { snap[files[i].id] = files[i].content }
            files[i].content = rule.action == "delete" ? "" : rule.payload
            files[i].modifiedAt = ISO8601DateFormatter().string(from: Date())
            files[i].size = files[i].content.utf8.count
            files[i].sha256 = Catalog.sha256(files[i].content)
        }
        backups[id] = snap
        if let i = patches.firstIndex(where: { $0.id == id }) { patches[i].isApplied = true }
        for i in shimFiles.indices where patch.rules.contains(where: { $0.path.hasSuffix(shimFiles[i].name) }) {
            shimFiles[i].modified = true
        }
        lastResult = "Đã áp dụng"; flash("Đã áp dụng"); log("apply:\(patch.name)"); persist()
    }
    func restorePatch(_ id: String) {
        guard can(.patch) else { flash("Vai trò hiện tại không đủ quyền"); return }
        let snap = backups[id] ?? [:]
        for i in files.indices {
            if let content = snap[files[i].id] {
                files[i].content = content
                files[i].size = content.utf8.count
                files[i].sha256 = Catalog.sha256(content)
                files[i].modifiedAt = ISO8601DateFormatter().string(from: Date())
            }
        }
        backups[id] = nil
        if let i = patches.firstIndex(where: { $0.id == id }) { patches[i].isApplied = false }
        lastResult = "Đã khôi phục"; flash("Đã khôi phục"); persist()
    }
    func clearPatches() { for p in patches where p.isApplied { restorePatch(p.id) }; flash("Đã gỡ patch đang hoạt động") }
    func changePassword(role: Role, next: String) {
        guard can(.password), !next.isEmpty else { return }
        if role == .owner { passwords.owner = next }
        if role == .admin { passwords.admin = next }
        flash("Đã lưu"); persist()
    }
    func hashFile(_ file: FileEntry) {
        hashName = file.name
        hashHex = file.sha256.isEmpty ? Catalog.sha256(file.content) : file.sha256
        hashSize = file.size
    }
    func scanCleaner() { cleaner = Catalog.cleaner; flash("Đã quét") }
    func deleteClean() {
        guard can(.clean) else { flash("Vai trò hiện tại không đủ quyền"); return }
        let freed = cleaner.filter { selectedClean.contains($0.id) }.reduce(0) { $0 + $1.size }
        cleaner.removeAll { selectedClean.contains($0.id) }
        selectedClean.removeAll(); flash("Đã giải phóng \(byte(freed))"); persist()
    }
    func installWallpaper(_ id: String) {
        for i in wallpapers.indices { wallpapers[i].installed = wallpapers[i].id == id }; persist()
    }
    func resetAll() {
        guard can(.reset) else { flash("Vai trò hiện tại không đủ quyền"); return }
        installed = []; files = Catalog.hashed(Catalog.files); patches = Catalog.patches
        backups = [:]; wallpapers = Catalog.wallpapers; shimFiles = Catalog.shimFiles; shimActive = false
        flash("Đã đặt lại dữ liệu cục bộ"); persist()
    }
    func flash(_ text: String) {
        toast = text
        Task { try? await Task.sleep(nanoseconds: 1_800_000_000); if toast == text { toast = nil } }
    }
    func log(_ message: String) {
        logs.insert(.init(id: nid("log"), at: ISO8601DateFormatter().string(from: Date()), message: message), at: 0)
        if logs.count > 80 { logs = Array(logs.prefix(80)) }
    }
    func byte(_ n: Int) -> String {
        if n < 1024 { return "\(n) B" }
        if n < 1_048_576 { return String(format: "%.1f KB", Double(n) / 1024) }
        return String(format: "%.1f MB", Double(n) / 1_048_576)
    }
    private func nid(_ p: String) -> String { "\(p)-\(UUID().uuidString.prefix(6))" }
    private func persist() {
        UserDefaults.standard.set(["terms": hasAcceptedTerms, "role": role?.rawValue as Any], forKey: persistKey)
    }
    private func load() {
        guard let data = UserDefaults.standard.dictionary(forKey: persistKey) else { return }
        hasAcceptedTerms = data["terms"] as? Bool ?? false
        if let raw = data["role"] as? String { role = Role(rawValue: raw) }
    }
}

struct RootView: View {
    @EnvironmentObject private var store: AppStore
    var body: some View {
        ZStack {
            Ink.bg.ignoresSafeArea()
            if !store.hasAcceptedTerms { TermsView() }
            else if store.role == nil { RoleGateView() }
            else { ShellView() }
        }
        .overlay(alignment: .top) {
            if let toast = store.toast {
                Text(toast).font(.system(size: 13, weight: .medium))
                    .padding(.horizontal, 16).padding(.vertical, 10)
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding(.top, 8)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: store.toast)
    }
}

struct TermsView: View {
    @EnvironmentObject private var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 12) {
                    Monogram()
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Shinn").font(.system(size: 20, weight: .semibold))
                        Text("Bảng điều khiển gói").font(.system(size: 13)).foregroundStyle(Ink.mute)
                    }
                }
                Text("Điều khoản sử dụng").font(.system(size: 28, weight: .semibold))
                Text("Shinn 2.0 là bảng điều khiển quản lý gói, tệp và cấu hình. Bản iOS này chỉ là giao diện — thay đổi nằm trong sandbox ảo, không tiêm vào ứng dụng khác.").foregroundStyle(Ink.mute)
                Text("Bạn chịu trách nhiệm với dữ liệu tự nhập. Không chia sẻ mật khẩu Owner / Admin.").foregroundStyle(Ink.mute)
                Button { store.acceptTerms() } label: {
                    Text("Tôi đồng ý và tiếp tục").font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity).padding(.vertical, 14)
                        .background(Ink.steel, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .foregroundStyle(Ink.bg)
                }
                Text("Bản iOS · sandbox cục bộ · \(AppMeta.version)").font(.system(size: 12, design: .monospaced)).foregroundStyle(Ink.mute)
            }.padding(24)
        }.foregroundStyle(Ink.steel)
    }
}

struct RoleGateView: View {
    @EnvironmentObject private var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HStack { Monogram(); Spacer(); Text("3105 Shinn").font(.system(size: 12, design: .monospaced)).foregroundStyle(Ink.mute) }
                Text("Chọn vai trò để kích hoạt").font(.system(size: 26, weight: .semibold))
                Text("Owner và Admin cần mật khẩu. Member vào thẳng.").foregroundStyle(Ink.mute)
                ForEach(Role.allCases) { role in
                    Button {
                        if role == .member || role == .support { _ = store.grant(role, password: "") }
                        else { store.pendingRole = role; store.passwordDraft = ""; store.passwordError = false }
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(role.title).font(.system(size: 16, weight: .semibold))
                                Text(role.subtitle).font(.system(size: 13)).foregroundStyle(Ink.mute)
                            }
                            Spacer()
                            Image(systemName: "chevron.right").font(.system(size: 12, weight: .semibold)).foregroundStyle(Ink.mute)
                        }
                        .padding(16)
                        .background(Ink.panel, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(Ink.line, lineWidth: 1))
                    }.foregroundStyle(Ink.steel)
                }
            }.padding(24)
        }
        .sheet(item: Binding(get: { store.pendingRole }, set: { store.pendingRole = $0 })) { role in
            PasswordSheet(role: role).environmentObject(store).presentationDetents([.medium])
        }
    }
}

struct PasswordSheet: View {
    @EnvironmentObject private var store: AppStore
    let role: Role
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Mật khẩu \(role.title)").font(.system(size: 20, weight: .semibold))
            SecureField("Nhập mật khẩu", text: $store.passwordDraft)
                .textContentType(.password).padding(12)
                .background(Ink.panel, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Ink.line))
            if store.passwordError { Text("Sai mật khẩu").foregroundStyle(Ink.warn).font(.system(size: 13)) }
            HStack {
                Button("Hủy") { store.pendingRole = nil }.foregroundStyle(Ink.mute)
                Spacer()
                Button("Xác nhận") { _ = store.grant(role, password: store.passwordDraft) }.fontWeight(.semibold)
            }
            Spacer()
        }.padding(24).foregroundStyle(Ink.steel).background(Ink.bg)
    }
}

struct ShellView: View {
    @EnvironmentObject private var store: AppStore
    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch store.route {
                case .home: HomeView()
                case .sources: SourcesView()
                case .installed: InstalledView()
                case .files: FilesView()
                case .more: MoreView()
                case .tool(let id): ToolScreen(id: id)
                case .package(let id): PackageDetail(id: id)
                case .patch(let id): PatchDetail(id: id)
                case .source(let id): SourceDetail(id: id)
                case .about: AboutView()
                case .logs: LogsView()
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            HStack(spacing: 0) {
                ForEach(TabID.allCases) { tab in
                    Button { store.setTab(tab) } label: {
                        VStack(spacing: 4) {
                            Image(systemName: tab.symbol).font(.system(size: 16, weight: store.tab == tab ? .semibold : .regular))
                            Text(tab.title).font(.system(size: 10, weight: store.tab == tab ? .semibold : .regular))
                        }
                        .frame(maxWidth: .infinity).padding(.vertical, 10)
                        .foregroundStyle(store.tab == tab ? Ink.steel : Ink.mute)
                    }
                }
            }
            .padding(.horizontal, 8).background(.ultraThinMaterial).overlay(Divider(), alignment: .top)
        }
        .background(Ink.bg.ignoresSafeArea()).foregroundStyle(Ink.steel)
    }
}

struct HomeView: View {
    @EnvironmentObject private var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    Monogram()
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Xin chào, \(store.role?.title ?? "")").font(.system(size: 13)).foregroundStyle(Ink.mute)
                        Text("Shinn").font(.system(size: 22, weight: .semibold))
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Đã kết nối").font(.system(size: 11, design: .monospaced)).foregroundStyle(Ink.ok)
                        Text("Free · Community").font(.system(size: 10)).foregroundStyle(Ink.mute)
                    }
                }
                Text("Công cụ gọn — kiểm soát rõ").font(.system(size: 15)).foregroundStyle(Ink.mute)
                Surface {
                    Text("Nổi bật").font(.system(size: 12, weight: .medium)).foregroundStyle(Ink.mute)
                    ForEach(store.allPackages().filter(\.featured)) { pkg in
                        Button { store.go(.package(pkg.identifier)) } label: {
                            HStack {
                                Image(systemName: ToolID(rawValue: pkg.icon)?.symbol ?? "shippingbox")
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(pkg.name).font(.system(size: 15, weight: .medium))
                                    Text(pkg.summary).font(.system(size: 12)).foregroundStyle(Ink.mute).lineLimit(1)
                                }
                                Spacer()
                                Image(systemName: "chevron.right").font(.caption).foregroundStyle(Ink.mute)
                            }.foregroundStyle(Ink.steel)
                        }
                    }
                }
                Text("Tất cả công cụ").font(.system(size: 13, weight: .medium)).foregroundStyle(Ink.mute)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(ToolID.allCases) { tool in
                        Button { store.go(.tool(tool)) } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                Image(systemName: tool.symbol).font(.system(size: 18))
                                Text(tool.title).font(.system(size: 14, weight: .medium)).multilineTextAlignment(.leading)
                                Text(tool.subtitle).font(.system(size: 11)).foregroundStyle(Ink.mute).lineLimit(2)
                            }
                            .padding(14).frame(maxWidth: .infinity, minHeight: 112, alignment: .topLeading)
                            .background(Ink.panel, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Ink.line))
                            .foregroundStyle(Ink.steel)
                        }
                    }
                }
            }.padding(20)
        }
    }
}

struct SourcesView: View {
    @EnvironmentObject private var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PageHead(title: "Nguồn", subtitle: "Catalog gói trong sandbox")
                HStack {
                    TextField("https://…/catalog.json", text: $store.newSourceURL)
                        .textInputAutocapitalization(.never).keyboardType(.URL)
                        .padding(10).background(Ink.panel, in: RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Ink.line))
                    Button("Thêm") { store.addSource() }.fontWeight(.semibold)
                }
                ForEach(store.sources) { src in
                    Button { store.go(.source(src.id)) } label: {
                        Surface {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text(src.name).font(.system(size: 16, weight: .semibold))
                                        if src.isDefault {
                                            Text("Mặc định").font(.system(size: 10, weight: .medium))
                                                .padding(.horizontal, 6).padding(.vertical, 2).background(Ink.line, in: Capsule())
                                        }
                                    }
                                    Text(src.url).font(.system(size: 12, design: .monospaced)).foregroundStyle(Ink.mute).lineLimit(1)
                                }
                                Spacer()
                                Text("\(store.allPackages().count) gói").font(.system(size: 12)).foregroundStyle(Ink.mute)
                            }
                        }
                    }.foregroundStyle(Ink.steel)
                }
                Text("Tất cả gói").font(.system(size: 13, weight: .medium)).foregroundStyle(Ink.mute)
                ForEach(store.allPackages()) { pkg in
                    Button { store.go(.package(pkg.identifier)) } label: {
                        Surface {
                            HStack(alignment: .top) {
                                Image(systemName: ToolID(rawValue: pkg.icon)?.symbol ?? "shippingbox")
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(pkg.name).font(.system(size: 15, weight: .medium))
                                    Text(pkg.summary).font(.system(size: 12)).foregroundStyle(Ink.mute)
                                    Text("\(pkg.version) · \(pkg.author)").font(.system(size: 11, design: .monospaced)).foregroundStyle(Ink.mute)
                                }
                                Spacer()
                            }
                        }
                    }.foregroundStyle(Ink.steel)
                }
            }.padding(20)
        }
    }
}

struct SourceDetail: View {
    @EnvironmentObject private var store: AppStore
    let id: String
    var src: SourceItem? { store.sources.first { $0.id == id } }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PageHead(title: src?.name ?? "Nguồn", subtitle: src?.url, back: { store.back() })
                if let src, !src.isDefault {
                    Button("Gỡ nguồn") { store.removeSource(src.id); store.back() }.foregroundStyle(Ink.warn)
                } else { Text("Không xóa được nguồn mặc định").foregroundStyle(Ink.mute) }
            }.padding(20)
        }
    }
}

struct InstalledView: View {
    @EnvironmentObject private var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PageHead(title: "Đã cài", subtitle: "\(store.installed.count) gói")
                if store.installed.isEmpty { Surface { Text("Chưa có mục nào").foregroundStyle(Ink.mute) } }
                ForEach(store.installed) { item in
                    Surface {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.name).font(.system(size: 15, weight: .medium))
                                Text("v\(item.version)").font(.system(size: 12, design: .monospaced)).foregroundStyle(Ink.mute)
                            }
                            Spacer()
                            Button("Gỡ") { store.uninstall(item.id) }.font(.system(size: 13, weight: .medium)).foregroundStyle(Ink.warn)
                        }
                    }
                }
            }.padding(20)
        }
    }
}

struct PackageDetail: View {
    @EnvironmentObject private var store: AppStore
    let id: String
    var pkg: CatalogPackage? { store.allPackages().first { $0.identifier == id } }
    var installed: Bool { store.installed.contains { $0.packageId == id } }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PageHead(title: pkg?.name ?? "Gói", subtitle: pkg?.summary, back: { store.back() })
                if let pkg {
                    Surface {
                        kv("Tác giả", pkg.author); kv("Phiên bản", pkg.version)
                        kv("Danh mục", pkg.category); kv("Kích thước", store.byte(pkg.size)); kv("SHA-256", pkg.sha256)
                    }
                    Text(pkg.description).foregroundStyle(Ink.mute)
                    if installed {
                        Text("Đã cài").font(.system(size: 14, weight: .semibold)).foregroundStyle(Ink.ok)
                    } else {
                        Button { store.install(pkg.identifier) } label: {
                            Text(store.installingId == pkg.identifier ? "Đang cài…" : "Cài đặt").fontWeight(.semibold)
                                .frame(maxWidth: .infinity).padding(.vertical, 12)
                                .background(Ink.steel, in: RoundedRectangle(cornerRadius: 12)).foregroundStyle(Ink.bg)
                        }.disabled(store.installingId != nil)
                    }
                }
            }.padding(20)
        }
    }
}

struct FilesView: View {
    @EnvironmentObject private var store: AppStore
    var rows: [FileEntry] {
        store.files.filter { f in
            f.area == store.fileArea && (store.showHidden || !f.hidden)
            && (store.query.isEmpty || f.name.localizedCaseInsensitiveContains(store.query) || f.path.localizedCaseInsensitiveContains(store.query))
        }
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                PageHead(title: "Tệp", subtitle: "Sandbox ảo · SHA-256")
                Picker("Khu vực", selection: $store.fileArea) {
                    ForEach(FileArea.allCases) { a in Text(a.title).tag(a) }
                }.pickerStyle(.segmented)
                HStack {
                    TextField("Tìm kiếm", text: $store.query).padding(10).background(Ink.panel, in: RoundedRectangle(cornerRadius: 10))
                    Toggle("Hiện tệp ẩn", isOn: $store.showHidden).labelsHidden()
                    Text("Ẩn").font(.system(size: 11)).foregroundStyle(Ink.mute)
                }
                if rows.isEmpty { Surface { Text("Không có kết quả").foregroundStyle(Ink.mute) } }
                ForEach(rows) { file in
                    Surface {
                        HStack(alignment: .top) {
                            Image(systemName: file.isDirectory ? "folder.fill" : "doc")
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(file.name).font(.system(size: 15, weight: .medium))
                                    if file.isFavorite { Image(systemName: "star.fill").font(.system(size: 10)).foregroundStyle(Ink.warn) }
                                    if file.hidden { Text("ẩn").font(.system(size: 10)).foregroundStyle(Ink.mute) }
                                }
                                Text(file.path).font(.system(size: 11, design: .monospaced)).foregroundStyle(Ink.mute).lineLimit(2)
                                if !file.isDirectory {
                                    Text(file.sha256).font(.system(size: 10, design: .monospaced)).foregroundStyle(Ink.mute).lineLimit(1)
                                    Text(store.byte(file.size)).font(.system(size: 11)).foregroundStyle(Ink.mute)
                                }
                            }
                            Spacer(minLength: 0)
                            Button { store.toggleFavorite(file.id) } label: {
                                Image(systemName: file.isFavorite ? "star.fill" : "star")
                            }.foregroundStyle(Ink.steel)
                        }
                    }
                    .onTapGesture {
                        if !file.isDirectory { store.hashFile(file); store.go(.tool(.hash)) }
                    }
                }
            }.padding(20)
        }
    }
}

struct MoreView: View {
    @EnvironmentObject private var store: AppStore
    @State private var nextPass = ""
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PageHead(title: "Thêm", subtitle: store.role?.title)
                Surface {
                    nav("Thông tin thiết bị", "iphone") { store.go(.tool(.device)) }
                    nav("Patch", "puzzlepiece") { store.go(.tool(.patches)) }
                    nav("Lớp cấu hình", "square.stack.3d.up") { store.go(.tool(.shim)) }
                    nav("Dọn dẹp", "trash") { store.go(.tool(.cleaner)) }
                    nav("Hình nền", "paintbrush") { store.go(.tool(.wallpaper)) }
                    nav("Cập nhật", "arrow.triangle.2.circlepath") { store.go(.tool(.updates)) }
                    nav("Giới thiệu", "info.circle") { store.go(.about) }
                    nav("Nhật ký", "list.bullet.rectangle") { store.go(.logs) }
                }
                Surface {
                    Text("Dữ liệu").font(.system(size: 13, weight: .medium)).foregroundStyle(Ink.mute)
                    Button("Gỡ patch đang hoạt động") { store.clearPatches() }
                    Button("Đặt lại") { store.resetAll() }.foregroundStyle(Ink.warn)
                }
                Surface {
                    Text("Đổi mật khẩu").font(.system(size: 13, weight: .medium)).foregroundStyle(Ink.mute)
                    SecureField("Mật khẩu mới", text: $nextPass).padding(10).background(Ink.bg, in: RoundedRectangle(cornerRadius: 10))
                    Button("Lưu Owner") { store.changePassword(role: .owner, next: nextPass); nextPass = "" }
                    Button("Lưu Admin") { store.changePassword(role: .admin, next: nextPass); nextPass = "" }
                }
                Button("Đăng xuất vai trò") { store.signOut() }
                    .fontWeight(.semibold).frame(maxWidth: .infinity).padding(.vertical, 12)
                    .background(Ink.panel, in: RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Ink.line))
            }.padding(20)
        }
    }
    private func nav(_ title: String, _ symbol: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: symbol); Text(title); Spacer()
                Image(systemName: "chevron.right").font(.caption).foregroundStyle(Ink.mute)
            }.foregroundStyle(Ink.steel)
        }
    }
}

struct AboutView: View {
    @EnvironmentObject private var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                PageHead(title: "Giới thiệu", subtitle: "3105 Shinn", back: { store.back() })
                Surface {
                    Text("Shinn 2.0").font(.system(size: 18, weight: .semibold))
                    Text("Bảng điều khiển gói, tệp và cấu hình. Giao diện SwiftUI — sandbox ảo.").foregroundStyle(Ink.mute)
                    Text("Phiên bản \(AppMeta.version)  ·  Build \(AppMeta.build)").font(.system(size: 12, design: .monospaced))
                }
            }.padding(20)
        }
    }
}

struct LogsView: View {
    @EnvironmentObject private var store: AppStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                PageHead(title: "Nhật ký", back: { store.back() })
                if store.logs.isEmpty { Surface { Text("Chưa có mục nào").foregroundStyle(Ink.mute) } }
                ForEach(store.logs) { e in
                    Surface {
                        Text(e.at).font(.system(size: 11, design: .monospaced)).foregroundStyle(Ink.mute)
                        Text(e.message).font(.system(size: 13, design: .monospaced))
                    }
                }
            }.padding(20)
        }
    }
}

struct ToolScreen: View {
    @EnvironmentObject private var store: AppStore
    let id: ToolID
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PageHead(title: id.title, subtitle: id.subtitle, back: { store.back() })
                switch id {
                case .files:
                    Text("Mở tab Tệp để duyệt sandbox.").foregroundStyle(Ink.mute)
                    Button("Mở tệp") { store.setTab(.files) }.fontWeight(.semibold)
                case .device: DeviceInfoCard()
                case .hash: HashCard()
                case .updates: UpdatesCard()
                case .cleaner: CleanerCard()
                case .wallpaper: WallpaperCard()
                case .patches: PatchesCard()
                case .shim: ShimCard()
                }
            }.padding(20)
        }
    }
}

struct DeviceInfoCard: View {
    var body: some View {
        Surface {
            kv("Bundle ID", Bundle.main.bundleIdentifier ?? "com.shinn.console")
            kv("Phiên bản", AppMeta.version); kv("Build", AppMeta.build)
            kv("Máy", UIDevice.current.model)
            kv("Hệ điều hành", "iOS \(UIDevice.current.systemVersion)")
            kv("Tên", UIDevice.current.name)
        }
    }
}

struct HashCard: View {
    @EnvironmentObject private var store: AppStore
    var body: some View {
        Surface {
            if store.hashHex.isEmpty {
                Text("Chọn một tệp ở tab Tệp để băm.").foregroundStyle(Ink.mute)
            } else {
                kv("Tên", store.hashName); kv("Kích thước", store.byte(store.hashSize))
                Text("SHA-256").font(.system(size: 12)).foregroundStyle(Ink.mute)
                Text(store.hashHex).font(.system(size: 12, design: .monospaced)).textSelection(.enabled)
                Button("Sao chép hash") { UIPasteboard.general.string = store.hashHex; store.flash("Đã sao chép") }
            }
        }
        ForEach(store.files.filter { !$0.isDirectory && !$0.hidden }) { f in
            Button { store.hashFile(f) } label: {
                HStack { Text(f.name); Spacer(); Text(store.byte(f.size)).foregroundStyle(Ink.mute) }
                    .foregroundStyle(Ink.steel).padding(.vertical, 6)
            }
        }
    }
}

struct UpdatesCard: View {
    @EnvironmentObject private var store: AppStore
    var body: some View {
        Surface {
            kv("Ứng dụng", "\(AppMeta.version) · đang dùng bản mới nhất")
            Text("Gói").font(.system(size: 12)).foregroundStyle(Ink.mute)
            ForEach(store.installed) { item in
                HStack {
                    Text(item.name); Spacer()
                    Text(item.hasUpdate ? "Có cập nhật" : "Mới nhất").foregroundStyle(item.hasUpdate ? Ink.warn : Ink.ok)
                }.font(.system(size: 13))
            }
            if store.installed.isEmpty { Text("Chưa có gói đã cài").foregroundStyle(Ink.mute) }
        }
    }
}

struct CleanerCard: View {
    @EnvironmentObject private var store: AppStore
    var body: some View {
        HStack {
            Button("Quét") { store.scanCleaner() }; Spacer()
            Button("Xóa đã chọn") { store.deleteClean() }.foregroundStyle(Ink.warn)
        }.fontWeight(.semibold)
        if store.cleaner.isEmpty { Surface { Text("Không có mục dọn").foregroundStyle(Ink.mute) } }
        ForEach(store.cleaner) { item in
            Button {
                if store.selectedClean.contains(item.id) { store.selectedClean.remove(item.id) }
                else { store.selectedClean.insert(item.id) }
            } label: {
                Surface {
                    HStack {
                        Image(systemName: store.selectedClean.contains(item.id) ? "checkmark.circle.fill" : "circle")
                        VStack(alignment: .leading) {
                            Text(item.path).font(.system(size: 14, design: .monospaced))
                            Text(item.kind).font(.system(size: 12)).foregroundStyle(Ink.mute)
                        }
                        Spacer()
                        Text(store.byte(item.size)).font(.system(size: 12, design: .monospaced))
                    }
                }
            }.foregroundStyle(Ink.steel)
        }
        Button("Chọn tất cả") { store.selectedClean = Set(store.cleaner.map(\.id)) }
    }
}

struct WallpaperCard: View {
    @EnvironmentObject private var store: AppStore
    var body: some View {
        ForEach(store.wallpapers) { pack in
            Surface {
                HStack {
                    Circle().fill(Color(hex: pack.tone)).frame(width: 22, height: 22)
                    VStack(alignment: .leading) {
                        Text(pack.name).font(.system(size: 15, weight: .medium))
                        Text(pack.tone).font(.system(size: 12, design: .monospaced)).foregroundStyle(Ink.mute)
                    }
                    Spacer()
                    Button(pack.installed ? "Gỡ gói" : "Cài gói") {
                        if pack.installed {
                            for i in store.wallpapers.indices { store.wallpapers[i].installed = false }
                        } else { store.installWallpaper(pack.id) }
                    }
                }
            }
        }
    }
}

struct PatchesCard: View {
    @EnvironmentObject private var store: AppStore
    var body: some View {
        Text("Patch Engine · container ảo").font(.system(size: 12, design: .monospaced)).foregroundStyle(Ink.mute)
        ForEach(store.patches) { p in
            Button { store.go(.patch(p.id)) } label: {
                Surface {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(p.name).font(.system(size: 15, weight: .medium))
                            Text(p.summary).font(.system(size: 12)).foregroundStyle(Ink.mute)
                        }
                        Spacer()
                        Text(p.isApplied ? "Đã áp dụng" : "Nghỉ")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(p.isApplied ? Ink.ok : Ink.mute)
                    }
                }
            }.foregroundStyle(Ink.steel)
        }
    }
}

struct PatchDetail: View {
    @EnvironmentObject private var store: AppStore
    let id: String
    var patch: PatchItem? { store.patches.first { $0.id == id } }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PageHead(title: patch?.name ?? "Patch", subtitle: patch?.summary, back: { store.back() })
                if let patch {
                    Surface {
                        kv("Tác giả", patch.author); kv("Phiên bản", patch.version)
                        kv("Trạng thái", patch.isApplied ? "Đang hoạt động" : "Nghỉ")
                    }
                    Surface {
                        Text("Mục tiêu").font(.system(size: 12)).foregroundStyle(Ink.mute)
                        ForEach(patch.targets, id: \.self) { t in Text(t).font(.system(size: 12, design: .monospaced)) }
                    }
                    Surface {
                        Text("Quy tắc").font(.system(size: 12)).foregroundStyle(Ink.mute)
                        ForEach(patch.rules) { r in Text("\(r.action)  \(r.path)").font(.system(size: 12, design: .monospaced)) }
                    }
                    if let result = store.lastResult { Text(result).foregroundStyle(Ink.ok) }
                    HStack {
                        Button("Áp dụng") { store.applyPatch(patch.id) }
                            .fontWeight(.semibold).padding(.horizontal, 16).padding(.vertical, 10)
                            .background(Ink.steel, in: Capsule()).foregroundStyle(Ink.bg)
                        Button("Khôi phục") { store.restorePatch(patch.id) }.fontWeight(.semibold)
                    }
                    Text("Chỉ sửa tệp ảo trong app — không ghi vào game hay hệ thống.")
                        .font(.system(size: 12)).foregroundStyle(Ink.mute)
                }
            }.padding(20)
        }
    }
}

struct ShimCard: View {
    @EnvironmentObject private var store: AppStore
    var body: some View {
        Surface {
            Toggle("Kích hoạt", isOn: $store.shimActive)
            Toggle("Hiện icon trên Home", isOn: $store.shimShowIcon)
            Toggle("Ghi log hoạt động", isOn: $store.shimLog)
        }
        Surface {
            Text("Ứng dụng mục tiêu").font(.system(size: 12)).foregroundStyle(Ink.mute)
            ForEach($store.shimGames) { $g in
                Toggle(isOn: $g.enabled) {
                    VStack(alignment: .leading) {
                        Text(g.name)
                        Text(g.bundleID).font(.system(size: 11, design: .monospaced)).foregroundStyle(Ink.mute)
                    }
                }
            }
        }
        Surface {
            Text("Tệp cấu hình").font(.system(size: 12)).foregroundStyle(Ink.mute)
            ForEach(store.shimFiles) { f in
                HStack {
                    Text(f.name).font(.system(size: 13, design: .monospaced)); Spacer()
                    Text(f.modified ? "Đã sửa" : "Gốc").foregroundStyle(f.modified ? Ink.warn : Ink.mute)
                }
            }
        }
    }
}

func kv(_ k: String, _ v: String) -> some View {
    HStack(alignment: .top) {
        Text(k).foregroundStyle(Ink.mute); Spacer()
        Text(v).font(.system(size: 13, design: .monospaced)).multilineTextAlignment(.trailing)
    }.font(.system(size: 13))
}

extension Color {
    init(hex: String) {
        var h = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if h.count == 6 { h += "FF" }
        var n: UInt64 = 0
        Scanner(string: h).scanHexInt64(&n)
        self.init(.sRGB, red: Double((n >> 24) & 0xFF) / 255, green: Double((n >> 16) & 0xFF) / 255, blue: Double((n >> 8) & 0xFF) / 255, opacity: Double(n & 0xFF) / 255)
    }
}