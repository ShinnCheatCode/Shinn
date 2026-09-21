import Foundation

struct InstalledItem: Identifiable {
    let id: String
    let name: String
    let iconName: String
    let type: PackageType
    var hasUpdate: Bool
}

enum PackageType: String {
    case patch, wallpaper, dialer, feature

    var label: String {
        switch self {
        case .patch:     return "Patch"
        case .wallpaper: return "Wallpaper"
        case .dialer:    return "Dialer"
        case .feature:   return "Feature"
        }
    }
}