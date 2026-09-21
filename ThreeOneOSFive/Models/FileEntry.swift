import Foundation

struct FileEntry: Identifiable {
    let id: String
    let name: String
    let isDirectory: Bool
    let size: Int64
    var isFavorite: Bool
}