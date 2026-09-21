import Foundation

struct Patch: Identifiable, Codable {
    let id: String
    let name: String
    let version: String
    let author: String
    let summary: String
    let targets: [String]
    let password: String?
    let rules: [PatchRule]
    var isApplied: Bool
}