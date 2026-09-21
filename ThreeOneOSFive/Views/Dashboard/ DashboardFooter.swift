import SwiftUI

struct DashboardFooter: View {
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: "heart.fill").foregroundStyle(.pink)
                Text("Free · Community Edition").font(.caption)
            }
            Text("3105Shinn").font(.caption2).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 12)
    }
}