import Foundation

enum TargetApps {
    static let allowed: [String] = [
        "com.dts.freefiremax",
        "com.dts.freefireth",
        "com.garena.game.kgvn"
    ]
    static func isAllowed(_ bundleID: String) -> Bool { allowed.contains(bundleID) }
    static func displayName(for bundleID: String) -> String {
        switch bundleID {
        case "com.dts.freefiremax":  return "Free Fire MAX"
        case "com.dts.freefireth":   return "Free Fire"
        case "com.garena.game.kgvn": return "Liên Quân Mobile"
        default:                     return bundleID
        }
    }
}