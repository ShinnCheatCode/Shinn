import SwiftUI

struct FilesView: View {
    @EnvironmentObject var appState: AppState
    @State private var area: FileArea = .workspace
    @State private var showHidden: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("", selection: $area) {
                    Text("Workspace").tag(FileArea.workspace)
                    Text("Application").tag(FileArea.application)
                    Text("App Group").tag(FileArea.appGroup)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                List {
                    ForEach(appState.files.entries(in: area, includeHidden: showHidden)) { entry in
                        HStack {
                            Image(systemName: entry.isDirectory ? "folder" : "doc")
                            Text(entry.name)
                            Spacer()
                            if entry.isFavorite {
                                Image(systemName: "star.fill").foregroundStyle(.yellow)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Files")
            .toolbar {
                Toggle(isOn: $showHidden) { Image(systemName: "eye") }
            }
        }
    }
}

enum FileArea: Hashable {
    case workspace, application, appGroup
}