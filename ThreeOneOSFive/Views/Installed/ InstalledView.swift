import SwiftUI

struct InstalledView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            List {
                ForEach(appState.installed.items) { item in
                    HStack(spacing: 12) {
                        Image(systemName: item.iconName)
                            .frame(width: 32, height: 32)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.name).font(.body)
                            Text(item.type.label).font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        if item.hasUpdate {
                            StatusBadge(text: "Update", color: .orange)
                        }
                    }
                }
                .onDelete { indexSet in
                    appState.installed.remove(at: indexSet)
                }
            }
            .navigationTitle("Installed")
        }
    }
}