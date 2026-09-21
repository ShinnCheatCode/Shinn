import Foundation

final class PatchEngineBridge {
    func apply(patch: Patch) -> PatchResult {
        return (try? PatchManager.shared.apply(patch: patch))
            ?? PatchResult(success: false, appliedCount: 0, message: "Lỗi")
    }

    func restore(patch: Patch) -> PatchResult {
        return (try? PatchManager.shared.restore(patch: patch))
            ?? PatchResult(success: false, appliedCount: 0, message: "Lỗi")
    }
}