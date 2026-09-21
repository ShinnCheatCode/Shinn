import SwiftUI

struct PackageCard: View {
    let package: Package
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: package.iconURL) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Image(systemName: "shippingbox")
            }
            .frame(width: 40, height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            VStack(alignment: .leading, spacing: 4) {
                Text(package.name).font(.headline)
                Text(package.summary).font(.caption).foregroundStyle(.secondary)
                Text(package.category).font(.caption2).foregroundStyle(.tertiary)
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct ProgressBanner: View {
    let title: String
    let progress: Double
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.subheadline)
            ProgressView(value: progress)
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}