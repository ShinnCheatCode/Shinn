import SwiftUI
import UIKit

struct AboutView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Image(systemName: "crown.fill").font(.system(size: 44)).foregroundStyle(.purple)
                    Text("Shinn Cheat").font(.largeTitle.bold())
                    Text("v2.0").font(.headline).foregroundStyle(.secondary)
                    Text("Shinn Cheat v2.0 là ứng dụng tiện ích được thiết kế với giao diện đơn giản, hiện đại và dễ sử dụng.")
                    NavigationLink { SetupGuideView() } label: { linkRow(icon: "book", title: "Cài đặt & Sử dụng") }
                    NavigationLink { TermsView() } label: { linkRow(icon: "doc.text", title: "Điều khoản sử dụng") }
                    NavigationLink { CreatorView() } label: { linkRow(icon: "person.crop.circle", title: "Nhà sáng tạo") }
                }
                .padding(16)
            }
            .background(Color(red: 0.05, green: 0.07, blue: 0.15).ignoresSafeArea())
            .navigationTitle("Giới thiệu")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    private func linkRow(icon: String, title: String) -> some View {
        HStack {
            Image(systemName: icon)
            Text(title)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding().background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct SetupGuideView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Image(systemName: "book.fill").font(.system(size: 40)).foregroundStyle(.purple)
                    Text("Cài đặt & Sử dụng").font(.largeTitle.bold())
                    Text("Shinn Cheat v2.0").font(.headline).foregroundStyle(.secondary)
                    Text("Shinn Cheat v2.0 là ứng dụng tiện ích với giao diện đơn giản, hiện đại và dễ sử dụng.")
                    Text("Chức năng chính").font(.headline)
                    feature("iphone", "Hiển thị thông tin thiết bị")
                    feature("number", "Kiểm tra dung lượng và SHA-256 của file")
                    feature("wrench.and.screwdriver.fill", "Quản lý các patch và công cụ được tích hợp")
                    feature("icloud.and.arrow.down", "Hỗ trợ cập nhật phiên bản")
                    feature("person.3.fill", "Phân quyền Owner, Admin, Support và Member")
                    Text("Cách sử dụng").font(.headline)
                    step(1, "Tải patch cần sử dụng.")
                    step(2, "Chọn Áp dụng Patch.")
                    step(3, "Sau khi áp dụng, tiến hành sử dụng.")
                    step(4, "Sử dụng xong, chọn Khôi phục Patch để đưa file về trạng thái ban đầu.")
                    step(5, "Nên khôi phục sau khi sử dụng để hạn chế lỗi không mong muốn.")
                }
                .padding(16)
            }
            .background(Color(red: 0.05, green: 0.07, blue: 0.15).ignoresSafeArea())
            .navigationTitle("Cài đặt & Sử dụng")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    private func feature(_ icon: String, _ text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon).frame(width: 24, height: 24).foregroundStyle(.purple)
            Text(text)
        }
    }
    private func step(_ index: Int, _ text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(index).").font(.body.bold()).foregroundStyle(.purple).frame(width: 24, alignment: .leading)
            Text(text)
        }
    }
}

struct TermsView: View {
    @AppStorage("hasAcceptedTerms") private var hasAcceptedTerms: Bool = false
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Image(systemName: "doc.text.fill").font(.system(size: 40)).foregroundStyle(.purple)
                    Text("Điều khoản sử dụng").font(.largeTitle.bold())
                    Text("Shinn Cheat v2.0").font(.headline).foregroundStyle(.secondary)
                    Text("Vui lòng sử dụng ứng dụng một cách thông minh và có trách nhiệm.")
                    Text("Khi bạn cài đặt hoặc sử dụng patch, bạn được xem là đã đọc, hiểu và đồng ý với các điều khoản sử dụng, đồng thời tự chịu mọi rủi ro có thể phát sinh trong quá trình sử dụng.")
                    Text("Nếu bạn không đồng ý với các điều khoản trên, vui lòng không sử dụng patch và xóa ứng dụng.")
                    Text("Xin cảm ơn").italic().foregroundStyle(.secondary)
                    Button { hasAcceptedTerms = true } label: {
                        Text("Tôi đồng ý").frame(maxWidth: .infinity).padding()
                            .background(.purple).foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    Button { dismiss() } label: {
                        Text("Không đồng ý").frame(maxWidth: .infinity).padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(16)
            }
            .background(Color(red: 0.05, green: 0.07, blue: 0.15).ignoresSafeArea())
            .navigationTitle("Điều khoản sử dụng")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CreatorView: View {
    @State private var copied: Bool = false
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Image(systemName: "person.crop.circle.badge.checkmark")
                        .font(.system(size: 40)).foregroundStyle(.purple)
                    Text("Nhà sáng tạo ứng dụng").font(.largeTitle.bold())
                    Text("Shinn Cheat v2.0").font(.headline).foregroundStyle(.secondary)
                    infoRow(icon: "hammer.fill", title: "Build & make", value: "NgVuMinhHieuu")
                    infoRow(icon: "shippingbox", title: "App gốc", value: "3105 YangJiiii")
                    Text("Liên hệ").font(.headline)
                    telegramRow(icon: "paperplane.fill", title: "Telegram Admin", value: "@ShinnThieuu", tgURL: "tg://resolve?domain=ShinnThieuu", webURL: "https://t.me/ShinnThieuu")
                    telegramRow(icon: "square.and.arrow.up", title: "Group Share", value: "t.me/ShinnCheatShare", tgURL: "tg://resolve?domain=ShinnCheatShare", webURL: "https://t.me/ShinnCheatShare")
                    telegramRow(icon: "bubble.left.and.bubble.right.fill", title: "Group Chat", value: "t.me/ShinnCheatChat", tgURL: "tg://resolve?domain=ShinnCheatChat", webURL: "https://t.me/ShinnCheatChat")
                    Text("Donate").font(.headline)
                    Button {
                        UIPasteboard.general.string = "104877777"
                        copied = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { copied = false }
                    } label: {
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "banknote.fill").frame(width: 24, height: 24).foregroundStyle(.purple)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("MB Bank").font(.caption).foregroundStyle(.secondary)
                                Text("104877777").font(.body)
                            }
                            Spacer()
                            Image(systemName: copied ? "checkmark" : "doc.on.doc")
                                .foregroundStyle(copied ? .green : .secondary)
                        }
                    }
                    .buttonStyle(.plain)
                    if copied {
                        Text("Đã sao chép số tài khoản").font(.caption).foregroundStyle(.green)
                    }
                }
                .padding(16)
            }
            .background(Color(red: 0.05, green: 0.07, blue: 0.15).ignoresSafeArea())
            .navigationTitle("Nhà sáng tạo")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    private func infoRow(icon: String, title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon).frame(width: 24, height: 24).foregroundStyle(.purple)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.caption).foregroundStyle(.secondary)
                Text(value).font(.body)
            }
        }
    }
    private func telegramRow(icon: String, title: String, value: String, tgURL: String, webURL: String) -> some View {
        Button {
            if let tg = URL(string: tgURL), UIApplication.shared.canOpenURL(tg) {
                UIApplication.shared.open(tg)
            } else if let web = URL(string: webURL) {
                UIApplication.shared.open(web)
            }
        } label: {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: icon).frame(width: 24, height: 24).foregroundStyle(.purple)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.caption).foregroundStyle(.secondary)
                    Text(value).font(.body).foregroundStyle(.blue)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(.secondary)
            }
        }
        .buttonStyle(.plain)
    }
}