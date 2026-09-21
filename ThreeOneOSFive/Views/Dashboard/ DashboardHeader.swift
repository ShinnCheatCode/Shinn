import SwiftUI

struct DashboardHeader: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "crown.fill")
                .font(.title)
                .foregroundStyle(.purple)

            VStack(alignment: .leading, spacing: 2) {
                Text("Shinn Cheat").font(.title2.bold())
                Text("v2.0").font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            NavigationLink {
                SettingsView()
            } label: {
                Image(systemName: "gearshape.fill")
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
        }
        .padding(.top, 8)
    }
}