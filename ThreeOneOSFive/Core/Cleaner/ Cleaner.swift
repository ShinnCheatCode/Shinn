import Foundation

final class Cleaner {
    func scan(bundleID: String) -> CleanerScanResult {
        CleanerScanResult(items: [], totalSize: 0)
    }

    func delete(items: [CleanerItem]) -> CleanerResult {
        CleanerResult(deletedCount: 0, freedSize: 0)
    }
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