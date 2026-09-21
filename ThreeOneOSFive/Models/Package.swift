import Foundation

struct Package: Identifiable, Codable {
    let identifier: String
    let name: String
    let author: String
    let version: String
    let summary: String
    let description: String
    let category: String
    let tags: [String]
    let publishedAt: Date
    let download: String
    let sha256: String
    let size: Int64
    let supportedOS: [SupportedOS]
    let featured: Bool
    let isPrivate: Bool
    let icon: String

    var id: String { identifier }
    var downloadURL: URL? { URL(string: download) }
    var iconURL: URL? { URL(string: icon) }
}

struct SupportedOS: Codable {
    let minimum: String
    let maximum: String
    let builds: [String]?
}