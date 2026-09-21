import SwiftUI

struct RoleGrid: View {
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            RoleCard(icon: "crown.fill", title: "Owner", subtitle: "Quyền cao nhất", color: .purple)
            RoleCard(icon: "checkmark.shield.fill", title: "Admin", subtitle: "Quản lý hệ thống", color: .blue)
            RoleCard(icon: "headphones", title: "Support", subtitle: "Hỗ trợ người dùng", color: .green)
            RoleCard(icon: "person.3.fill", title: "Member", subtitle: "Thành viên", color: .pink)
        }
    }
}

struct RoleCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        NavigationLink {
            RoleDetailView(title: title)
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