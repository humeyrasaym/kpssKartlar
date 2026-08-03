import SwiftUI

@main
struct KPSSKartlarApp: App {
    @StateObject private var studyController = StudyController()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(studyController)
                .preferredColorScheme(.light)
        }
    }
}
