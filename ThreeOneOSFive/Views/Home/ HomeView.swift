import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var segment: HomeSegment = .forYou

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // MARK: - Segment Picker
                Picker("", selection: $segment) {
                    Text("For You")
                        .tag(HomeSegment.forYou)

                    Text("New")
                        .tag(HomeSegment.new)

                    Text("Sources")
                        .tag(HomeSegment.sources)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 8)

                // MARK: - Package List
                List {
                    ForEach(
                        appState.marketplace.packages(for: segment)
                    ) { pkg in
                        PackageCard(package: pkg)
                            .listRowInsets(
                                EdgeInsets(
                                    top: 6,
                                    leading: 16,
                                    bottom: 6,
                                    trailing: 16
                                )
                            )
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            .navigationTitle("3105")
            .navigationBarTitleDisplayMode(.large)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
    }
}

// MARK: - Home Segment

enum HomeSegment: Hashable {
    case forYou
    case new
    case sources
}

#Preview {
    HomeView()
}