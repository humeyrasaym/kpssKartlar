import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Bugün", systemImage: "sun.max.fill") }
            CourseLibraryView()
                .tabItem { Label("Kartlar", systemImage: "rectangle.stack.fill") }
            KnownCardsView()
                .tabItem { Label("Öğrendim", systemImage: "checkmark.circle.fill") }
            ProgressScreen()
                .tabItem { Label("İlerleme", systemImage: "chart.bar.fill") }
        }
        .tint(AppTheme.ink)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.paper.ignoresSafeArea())
    }
}
