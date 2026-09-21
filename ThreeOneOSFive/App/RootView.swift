import SwiftUI

struct RootView: View {
    @State private var selectedTab: Tab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem { Label("Home", systemImage: "house") }
                .tag(Tab.home)
            SourcesView()
                .tabItem { Label("Sources", systemImage: "square.stack.3d.up") }
                .tag(Tab.sources)
            InstalledView()
                .tabItem { Label("Installed", systemImage: "shippingbox") }
                .tag(Tab.installed)
            FilesView()
                .tabItem { Label("Files", systemImage: "folder") }
                .tag(Tab.files)
            ShimCheatRootView()
                .tabItem { Label("ShimCheat", systemImage: "wand.and.stars") }
                .tag(Tab.shimCheat)
            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape") }
                .tag(Tab.settings)
        }
    }
}

enum Tab: Hashable {
    case home, sources, installed, files, shimCheat, settings
}