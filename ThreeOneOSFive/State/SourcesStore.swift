import Foundation

final class SourcesStore: ObservableObject {
    @Published var items: [Source] = []

    init() { loadDefaults() }

    private func loadDefaults() {
        guard let url = Bundle.main.url(forResource: "default_repos", withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return }

        struct RepoFile: Decodable {
            let version: Int
            let repos: [RepoEntry]
        }
        struct RepoEntry: Decodable {
            let id: String
            let name: String
            let url: String
            let icon: String
            let enabled: Bool
            let isDefault: Bool?
        }

        guard let file = try? JSONDecoder().decode(RepoFile.self, from: data) else { return }
        items = file.repos
            .filter { $0.enabled }
            .map { Source(id: $0.id, name: $0.name, url: $0.url, isDefault: $0.isDefault ?? false) }
    }

    func add(url: String) {
        guard !url.isEmpty else { return }
        let source = Source(id: UUID().uuidString, name: url, url: url, isDefault: false)
        items.append(source)
    }

    func remove(at indexSet: IndexSet) {
        let filtered = indexSet.filter { !items[$0].isDefault }
        items.remove(atOffsets: IndexSet(filtered))
    }

    func refreshAll() { }
}