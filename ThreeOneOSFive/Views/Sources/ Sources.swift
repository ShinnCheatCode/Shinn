import SwiftUI

struct SourcesView: View {
    @EnvironmentObject var appState: AppState
    @State private var newSourceURL: String = ""

    var body: some View {
        NavigationStack {
            List {
                Section("Đã thêm") {
                    ForEach(appState.sources.items) { source in
                        NavigationLink { RepoDetailView(source: source) } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 6) {
                                    Text(source.name).font(.headline)
                                    if source.isDefault {
                                        StatusBadge(text: "Mặc định", color: .green)
                                    }
                                }
                                Text(source.url).font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        appState.sources.remove(at: indexSet)
                    }
                }
                Section("Thêm nguồn") {
                    TextField("https://...", text: $newSourceURL)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.URL)
                    Button("Thêm") {
                        appState.sources.add(url: newSourceURL)
                        newSourceURL = ""
                    }
                }
            }
            .navigationTitle("Sources")
            .toolbar {
                Button {
                    appState.sources.refreshAll()
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }
}

struct RepoDetailView: View {
    let source: Source
    @EnvironmentObject var appState: AppState
    var body: some View {
        List {
            Section {
                HStack(spacing: 12) {
                    Image(systemName: "shippingbox.fill").frame(width: 56, height: 56)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(source.name).font(.headline)
                        Text("Nguồn Repository").font(.caption).foregroundStyle(.secondary)
                        Text("\(appState.marketplace.packages.count) gói")
                            .font(.caption2).foregroundStyle(.tertiary)
                    }
                }
            }
            Section("Tag") {
                NavigationLink {
                    PackageListView(title: "Tất cả gói",
                                    packages: appState.marketplace.packages)
                } label: {
                    TagRow(title: "Tất cả gói",
                           count: appState.marketplace.packages.count)
                }
                ForEach(appState.marketplace.categories, id: \.self) { cat in
                    NavigationLink {
                        PackageListView(title: cat,
                                        packages: appState.marketplace.packages(category: cat))
                    } label: {
                        TagRow(title: cat,
                               count: appState.marketplace.count(category: cat))
                    }
                }
            }
        }
        .navigationTitle(source.name)
        .onAppear { appState.marketplace.load(repo: source.url) }
    }
}

struct TagRow: View {
    let title: String
    let count: Int
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "shippingbox").frame(width: 32, height: 32)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.body)
                Text("\(count) gói").font(.caption).foregroundStyle(.secondary)
            }
        }
    }
}

struct PackageListView: View {
    let title: String
    let packages: [Package]
    var body: some View {
        List(packages) { pkg in
            NavigationLink { PackageDetailView(package: pkg) } label: {
                HStack(spacing: 12) {
                    AsyncImage(url: pkg.iconURL) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Image(systemName: "shippingbox")
                    }
                    .frame(width: 44, height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(pkg.name).font(.body)
                        Text(pkg.summary).font(.caption).foregroundStyle(.secondary)
                        Text("\(pkg.author) · Phiên bản \(pkg.version)")
                            .font(.caption2).foregroundStyle(.tertiary)
                    }
                }
            }
        }
        .navigationTitle(title)
    }
}

struct PackageDetailView: View {
    let package: Package
    @State private var progress: Double = 0
    @State private var installing: Bool = false
    var body: some View {
        List {
            Section {
                HStack(spacing: 12) {
                    AsyncImage(url: package.iconURL) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Image(systemName: "shippingbox")
                    }
                    .frame(width: 64, height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    VStack(alignment: .leading, spacing: 4) {
                        Text(package.name).font(.headline)
                        Text(package.author).font(.caption).foregroundStyle(.secondary)
                        Text("Phiên bản \(package.version)")
                            .font(.caption2).foregroundStyle(.tertiary)
                    }
                }
            }
            Section("Mô tả") { Text(package.description) }
            Section("Thông tin") {
                Text("Tag: \(package.tags.joined(separator: ", "))")
                Text("Kích thước: \(package.size) bytes")
            }
            Section {
                if installing {
                    ProgressView(value: progress)
                } else {
                    Button("Cài đặt") { install() }
                }
            }
        }
        .navigationTitle(package.name)
    }
    private func install() {
        installing = true
    }
}