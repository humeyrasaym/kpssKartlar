import SwiftUI

@main
struct KPSSKartlarApp: App {
    @StateObject private var studyStore = StudyStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(studyStore)
                .preferredColorScheme(.light)
        }
    }
}
