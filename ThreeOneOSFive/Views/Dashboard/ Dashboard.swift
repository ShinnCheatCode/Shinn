import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var appState: AppState

    private let bg = Color(red: 0.05, green: 0.07, blue: 0.15)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    DashboardHeader()
                    WelcomeBanner(userName: "Shinn", status: .connected)

                    SectionTitle(icon: "person.2.fill",
                                 title: "Chọn vai trò đăng nhập")
                    RoleGrid()

                    HStack {
                        SectionTitle(icon: "wrench.and.screwdriver.fill",
                                     title: "Free Fire Tools")
                        Spacer()
                        NavigationLink("All Tools Free") {
                            ToolsGridView()
                        }
                        .font(.caption)
                    }
                    ToolsGrid()

                    DashboardFooter()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 88)
            }
            .scrollIndicators(.hidden)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(bg.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(bg.ignoresSafeArea())
    }
}