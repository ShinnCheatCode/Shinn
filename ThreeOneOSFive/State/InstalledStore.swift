import Foundation

final class InstalledStore: ObservableObject {
    @Published var items: [InstalledItem] = []

    func add(_ item: InstalledItem) { items.append(item) }
    func remove(at indexSet: IndexSet) { items.remove(atOffsets: indexSet) }
    func markUpdate(id: String) {
        if let i = items.firstIndex(where: { $0.id == id }) {
            items[i].hasUpdate = true
        }
    }
}