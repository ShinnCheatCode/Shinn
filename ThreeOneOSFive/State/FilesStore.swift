import Foundation

final class FilesStore: ObservableObject {
    @Published var entries: [FileEntry] = []
    @Published var currentPath: String = ""

    func entries(in area: FileArea, includeHidden: Bool) -> [FileEntry] {
        includeHidden ? entries : entries.filter { !$0.name.hasPrefix(".") }
    }

    func load(path: String) { currentPath = path }
}