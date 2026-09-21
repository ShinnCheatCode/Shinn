import Foundation

final class ShimCheatBridge {
    static let shared = ShimCheatBridge()
    func apply(bundleID: String, configPath: String) -> Bool { return false }
    func restore(bundleID: String) -> Bool { return false }
    func listTargets() -> [String] { return [] }
}