import SwiftUI

struct TermsView: View {
    @AppStorage("hasAcceptedTerms") private var hasAcceptedTerms: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 12) {
                        Image(systemName: "doc.text.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(.purple)
                        Text("Điều khoản sử dụng")
                            .font(.title.bold())
                            .foregroundStyle(.white)
                    }

                    Text("Điều khoản sử dụng")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)

                    Text("Shinn Cheat v2.0")
                        .font(.headline)
                        .foregroundStyle(.gray)

                    Text("Vui lòng sử dụng ứng dụng một cách thông minh và có trách nhiệm.")
                        .foregroundStyle(.white)

                    Text("Khi bạn cài đặt hoặc sử dụng patch, bạn được xem là đã đọc, hiểu và đồng ý với các điều khoản sử dụng, đồng thời tự chịu mọi rủi ro có thể phát sinh trong quá trình sử dụng.")
                        .foregroundStyle(.white)

                    Text("Nếu bạn không đồng ý với các điều khoản trên, vui lòng không sử dụng patch và xóa ứng dụng.")
                        .foregroundStyle(.white)

                    Text("Xin cảm ơn")
                        .italic()
                        .foregroundStyle(.gray)

                    Button {
                        hasAcceptedTerms = true
                    } label: {
                        Text("Tôi đồng ý")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(colors: [.purple, .blue],
                                                       startPoint: .leading,
                                                       endPoint: .trailing))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(20)
            }
            .background(Color(red: 0.04, green: 0.06, blue: 0.14).ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}