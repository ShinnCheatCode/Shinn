import Foundation

final class AppDataBrowser {
    func listApps() -> [AppEntry] { return [] }
    func containerPath(for bundleID: String) -> String? { return nil }
    func listFiles(at path: String) -> [FileEntry] { return [] }
}

struct AppEntry: Identifiable {
    let id: String
    let bundleID: String
    let name: String
}