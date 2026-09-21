import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var segment: HomeSegment = .forYou

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("", selection: $segment) {
                    Text("For You").tag(HomeSegment.forYou)
                    Text("New").tag(HomeSegment.new)
                    Text("Sources").tag(HomeSegment.sources)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                List {
                    ForEach(appState.marketplace.packages(for: segment)) { pkg in
                        PackageCard(package: pkg)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("3105")
        }
    }
}

enum HomeSegment: Hashable {
    case forYou, new, sources
}