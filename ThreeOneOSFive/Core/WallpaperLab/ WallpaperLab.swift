import Foundation

final class WallpaperLab {
    func importPackage(from path: String) -> WallpaperResult {
        WallpaperResult(success: false, message: "")
    }

    func install(package: WallpaperPackage) -> WallpaperResult {
        WallpaperResult(success: false, message: "")
    }

    func reset(package: WallpaperPackage) -> WallpaperResult {
        WallpaperResult(success: false, message: "")
    }
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