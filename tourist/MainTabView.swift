import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct MainTabView: View {
    @State private var selectedTab = 0
    @AppStorage("isAdmin") private var isAdmin = false

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            DealsListView()
                .tabItem {
                    Label("Deals & Promos", systemImage: "flame.fill")
                }
                .tag(1)

            FoodListView()
                .tabItem {
                    Label("Food & Drink", systemImage: "fork.knife")
                }
                .tag(2)

            BeachListView()
                .tabItem {
                    Label("Beaches", systemImage: "sun.max.fill")
                }
                .tag(3)

            ThingsListView()
                .tabItem {
                    Label("Things To Do", systemImage: "star.fill")
                }
                .tag(4)

            MapsListView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
                .tag(5)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(6)
        }
        .onAppear {
            let userID = Auth.auth().currentUser?.uid ?? UUID().uuidString
            ReferralManager.shared.logInstallToFirestore(userID: userID)
        }
        .onOpenURL { url in
            ReferralManager.shared.saveReferrerIfPresent(from: url)
        }
    }
}
