import SwiftUI

final class ShimCheatState: ObservableObject {
    @Published var isActive: Bool = false
    @Published var showIcon: Bool = true
    @Published var logEnabled: Bool = false
    @Published var patchPassword: String = ""
    @Published var version: String = "1.0"
    @Published var games: [ShimGame] = []
    @Published var configFiles: [ShimConfigFile] = []

    func backup() { }
    func restore() { }
    func clearAll() { }
}

struct ShimGame: Identifiable {
    let id = UUID()
    var name: String
    var bundleID: String
    var enabled: Bool
}

struct ShimConfigFile: Identifiable {
    let id = UUID()
    var name: String
    var modified: Bool
}