import Foundation

final class PatchManager {
    static let shared = PatchManager()

    func apply(patch: Patch) throws -> PatchResult {
        let targets = patch.targets.filter { TargetApps.isAllowed($0) }
        guard !targets.isEmpty else {
            return PatchResult(success: false, appliedCount: 0, message: "Không có target hợp lệ")
        }

        var applied = 0
        for bundleID in targets {
            guard let container = ContainerManagerBridge().containerPath(for: bundleID) else { continue }
            for rule in patch.rules {
                applyRule(rule, in: container)
            }
            applied += 1
        }

        return PatchResult(success: true, appliedCount: applied, message: "Đã áp dụng")
    }

    func restore(patch: Patch) throws -> PatchResult {
        let targets = patch.targets.filter { TargetApps.isAllowed($0) }
        var restored = 0
        for bundleID in targets {
            guard let container = ContainerManagerBridge().containerPath(for: bundleID) else { continue }
            try PatchBackup().restore(patch: patch, bundleID: bundleID, container: container)
            restored += 1
        }
        return PatchResult(success: true, appliedCount: restored, message: "Đã khôi phục")
    }

    private func applyRule(_ rule: PatchRule, in container: String) {
        let fullPath = (container as NSString).appendingPathComponent(rule.path)
        switch rule.action {
        case .replace, .plist, .json:
            if let data = rule.payload {
                try? data.write(to: URL(fileURLWithPath: fullPath), options: .atomic)
            }
        case .delete:
            try? FileManager.default.removeItem(atPath: fullPath)
        }
    }
}

struct PatchResult {
    let success: Bool
    let appliedCount: