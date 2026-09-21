import SwiftUI

struct RootView: View {
    @State private var selectedTab: Tab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(Tab.home)
            SourcesView()
                .tabItem { Label("Sources", systemImage: "square.stack.3d.up.fill") }
                .tag(Tab.sources)
            InstalledView()
                .tabItem { Label("Installed", systemImage: "shippingbox.fill") }
                .tag(Tab.installed)
            FilesView()
                .tabItem { Label("Files", systemImage: "folder.fill") }
                .tag(Tab.files)
            SettingsView()
                .tabItem { Label("More", systemImage: "ellipsis.circle.fill") }
                .tag(Tab.settings)
        }
        .tint(.blue)
    }
}

enum Tab: Hashable {
    case home, sources, installed, files, settings
}