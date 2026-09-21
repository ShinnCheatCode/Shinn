import Foundation

final class Cleaner {
    func scan(bundleID: String) -> CleanerScanResult { return CleanerScanResult() }
    func delete(items: [CleanerItem]) -> CleanerResult { return CleanerResult() }
}

struct CleanerScanResult {
    let items: [CleanerItem]
    let totalSize: Int64
}

struct CleanerItem: Identifiable {
    let id: String
    let path: String
    let size: Int64
}

struct CleanerResult {
    let deletedCount: Int
    let freedSize: Int64
}