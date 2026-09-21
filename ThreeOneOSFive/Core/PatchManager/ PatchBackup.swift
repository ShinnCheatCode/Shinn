import Foundation

final class PatchBackup {
    private var root: URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return base.appendingPathComponent("3105/backups", isDirectory: true)
    }

    func snapshot(patch: Patch, bundleID: String, container: String) throws {
        let dir = root.appendingPathComponent("\(patch.id)/\(bundleID)", isDirectory: true)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        for rule in patch.rules {
            let source = (container as NSString).appendingPathComponent(rule.path)
            guard FileManager.default.fileExists(atPath: source) else { continue }
            let dest = dir.appendingPathComponent(rule.path)
            try FileManager.default.createDirectory(at: dest.deletingLastPathComponent(), withIntermediateDirectories: true)
            try? FileManager.default.removeItem(at: dest)
            try FileManager.default.copyItem(at: URL(fileURLWithPath: source), to: dest)
        }
    }

    func restore(patch: Patch, bundleID: String, container: String) throws {
        let dir = root.appendingPathComponent("\(patch.id)/\(bundleID)", isDirectory: true)
        for rule in patch.rules {
            let source = dir.appendingPathComponent(rule.path)
            guard FileManager.default.fileExists(atPath: source.path) else { continue }
            let dest = (container as NSString).appendingPathComponent(rule.path)
            try? FileManager.default.removeItem(atPath: dest)
            try FileManager.default.copyItem(at: source, to: URL(fileURLWithPath: dest))
        }
        try? FileManager.default.removeItem(at: dir)
    }
}