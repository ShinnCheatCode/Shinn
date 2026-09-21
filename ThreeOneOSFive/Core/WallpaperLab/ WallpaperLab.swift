import Foundation

final class WallpaperLab {
    func importPackage(from path: String) -> WallpaperResult { return WallpaperResult() }
    func install(package: WallpaperPackage) -> WallpaperResult { return WallpaperResult() }
    func reset(package: WallpaperPackage) -> WallpaperResult { return WallpaperResult() }
}

struct WallpaperPackage: Identifiable {
    let id: String
    let name: String
    let path: String
}

struct WallpaperResult {
    let success: Bool
    let message: String
}