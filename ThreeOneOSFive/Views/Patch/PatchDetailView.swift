import SwiftUI

struct PatchDetailView: View {
    let patch: Patch
    @State private var result: PatchResult?

    var body: some View {
        List {
            Section("Thông tin") {
                Text(patch.name).font(.headline)
                Text("Tác giả: \(patch.author)")
                Text("Phiên bản: \(patch.version)")
            }

            Section("Mục tiêu") {
                ForEach(patch.targets, id: \.self) { id in
                    Text(id).font(.caption)
                }
            }

            Section("Hành động") {
                Button("Áp dụng patch") {
                    result = PatchEngineBridge().apply(patch: patch)
                }
                Button("Khôi phục", role: .destructive) {
                    result = PatchEngineBridge().restore(patch: patch)
                }
            }

            if let result {
                Section("Kết quả") {
                    Text(result.message)
                    Text("Thành công: \(result.appliedCount)")
                }
            }
        }
        .navigationTitle("Chi tiết")
    }
}