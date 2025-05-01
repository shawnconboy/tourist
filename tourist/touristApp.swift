import SwiftUI
import Firebase

@main
struct touristApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.light) // 👈 Forces light mode only
        }
    }
}
