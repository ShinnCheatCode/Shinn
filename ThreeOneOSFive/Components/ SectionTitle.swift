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