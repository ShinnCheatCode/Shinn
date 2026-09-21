import SwiftUI

final class AppState: ObservableObject {
    @Published var marketplace = MarketplaceStore()
    @Published var installed = InstalledStore()
    @Published var sources = SourcesStore()
    @Published var files = FilesStore()
    @Published var shimCheat = ShimCheatState()
    @Published var patches: [Patch] = []
    @Published var language: String = "vi"

    var allowedPatches: [Patch] {
        patches.filter { patch in
            patch.targets.contains { TargetApps.isAllowed($0) }
        }
    }

    func setLanguage(_ code: String) { language = code }
    func backup() { }
    func restore() { }
    func reset() { }
    func removeActivePatches() { }
}