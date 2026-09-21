import Foundation

final class ContainerManagerBridge {
    func listAppContainers() -> [ContainerEntry] { return [] }
    func listAppGroups() -> [ContainerEntry] { return [] }
    func containerPath(for bundleID: String) -> String? { return nil }
}

struct ContainerEntry: Identifiable {
    let id: String
    let name: String
    let path: String
}