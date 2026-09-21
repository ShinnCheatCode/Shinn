import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var appState: AppState

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
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .background(Color(red: 0.05, green: 0.07, blue: 0.15).ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}