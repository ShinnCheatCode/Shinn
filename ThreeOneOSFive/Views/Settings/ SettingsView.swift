import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @State private var language: String = "vi"

    var body: some View {
        NavigationStack {
            Form {
                Section("Ngôn ngữ") {
                    Picker("Language", selection: $language) {
                        Text("English").tag("en")
                        Text("Tiếng Việt").tag("vi")
                        Text("简体中文").tag("zh-Hans")
                    }
                    .onChange(of: language) { _, newValue in
                        appState.setLanguage(newValue)
                    }
                }

                Section("Dữ liệu") {
                    Button("Backup") { appState.backup() }
                    Button("Restore") { appState.restore() }
                    Button("Reset", role: .destructive) { appState.reset() }
                }

                Section("Patch") {
                    Button("Gỡ patch đang hoạt động", role: .destructive) {
                        appState.removeActivePatches()
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}