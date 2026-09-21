import SwiftUI

struct RoleDetailView: View {
    let title: String

    var body: some View {
        List {
            Text("Vai trò: \(title)")
            Text("Chưa triển khai logic vai trò.")
                .foregroundStyle(.secondary)
        }
        .navigationTitle(title)
    }
}