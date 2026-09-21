import SwiftUI

struct PatchListView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            List {
                ForEach(appState.allowedPatches) { patch in
                    NavigationLink {
                        PatchDetailView(patch: patch)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(patch.name).font(.headline)
                            Text(patch.summary).font(.caption).foregroundStyle(.secondary)
                            Text(patch.targets
                                .filter { TargetApps.isAllowed($0) }
                                .map { TargetApps.displayName(for: $0) }
                                .joined(separator: ", "))
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
            }
            .navigationTitle("Patch")
        }
    }
}