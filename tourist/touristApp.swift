import SwiftUI
import Firebase

@main
struct touristApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            SplashView() // 👈 Launch splash first
                .preferredColorScheme(.light)
        }
    }
}
