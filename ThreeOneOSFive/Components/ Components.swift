import SwiftUI

struct SectionTitle: View {
    let icon: String
    let title: String
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon).foregroundStyle(.purple)
            Text(title).font(.headline)
        }
    }
}

struct StatusBadge: View {
    let text: String
    let color: Color
    var body: some View {
        Text(text)
            .font(.caption2)
            .padding(.horizontal, 6).padding(.vertical, 2)
            .background(color.opacity(0.2))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}