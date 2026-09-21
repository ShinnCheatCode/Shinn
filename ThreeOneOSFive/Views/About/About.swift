import SwiftUI
import UIKit

struct AboutView: View {
    @State private var copied = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ZStack {
                    Circle().fill(Color.white.opacity(0.08)).frame(width: 88, height: 88)
                    Image(systemName: "crown.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(.white)
                }
                .padding(.top, 12)

                Text("SHINN CHEAT")
                    .font(.system(size: 26, weight: .heavy))
                    .foregroundStyle(.white)

                Text("Play Smart • Stay Ahead")
                    .font(.subheadline)
                    .foregroundStyle(Color.white.opacity(0.45))

                Text("App được make bởi Shinn")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.10))
                    .clipShape(Capsule())

                Text("Shinn Cheat là ứng dụng quản lý và phân phối các package được cấu hình thông qua repository của Shinn.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.white.opacity(0.55))
                    .padding(.horizontal, 8)
                    .padding(.top, 4)

                Text("Liên hệ")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 12)

                aboutRow(icon: "paperplane.fill", title: "Telegram", subtitle: "@ShinnThieuu", trailing: "arrow.up.right") {
                    openTG("ShinnThieuu")
                }
                aboutRow(icon: "heart.fill", title: "Donate • MB Bank", subtitle: "104877777", trailing: copied ? "checkmark" : "doc.on.doc") {
                    UIPasteboard.general.string = "104877777"
                    copied = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { copied = false }
                }
                aboutRow(icon: "arrow.triangle.2.circlepath", title: "Remote JSON", subtitle: "Cập nhật dữ liệu từ repository", trailing: "sparkle") {}
                aboutRow(icon: "checkmark.shield.fill", title: "SHA256", subtitle: "Kiểm tra tính toàn vẹn của file", trailing: "") {}
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .navigationTitle("Giới Thiệu")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.black, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    private func aboutRow(icon: String, title: String, subtitle: String, trailing: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 48, height: 48)
                    Image(systemName: icon).foregroundStyle(.white)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(title).font(.headline).foregroundStyle(.white)
                    Text(subtitle).font(.caption).foregroundStyle(Color.white.opacity(0.45))
                }
                Spacer()
                if !trailing.isEmpty {
                    Image(systemName