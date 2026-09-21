import SwiftUI

struct ToolsGridView: View {
    var body: some View {
        List {
            Text("File Manager")
            Text("Device Info")
            Text("SHA-256")
            Text("Updates")
        }
        .navigationTitle("All Tools")
    }
}