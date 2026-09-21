import Foundation

struct PatchRule: Identifiable, Codable {
    let id: String
    let path: String
    let action: PatchAction
    let payload: Data?

    var actionLabel: String {
        switch action {
        case .replace: return "Thay thế"
        case .plist:   return "Sửa plist"
        case .json:    return "Sửa JSON"
        case .delete:  return "Xóa"
        }
    }
}

enum PatchAction: String, Codable {
    case replace, plist, json, delete
}