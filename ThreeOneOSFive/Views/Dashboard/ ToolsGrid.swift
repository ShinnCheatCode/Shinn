import SwiftUI

struct ToolsGrid: View {
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ToolCard(icon: "folder.fill", title: "File Manager", subtitle: "Quản lý file dễ dàng", color: .blue)
            ToolCard(icon: "iphone", title: "Device Info", subtitle: "Thông tin thiết bị", color: .purple)
            ToolCard(icon: "number", title: "SHA-256", subtitle: "Kiểm tra file an toàn", color: .green)
            ToolCard(icon: "icloud.and.arrow.down", title: "Updates", subtitle: "Cập nhật phiên bản", color: .purple)
        }
    }
}

struct ToolCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        NavigationLink {
            ToolsGridView()
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: icon).font(.title2).foregroundStyle(color)
                Text(title).font(.headline)
                Text(subtitle).font(.caption).foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}