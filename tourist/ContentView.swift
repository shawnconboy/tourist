import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            BeachListView()
                .tabItem {
                    Label("Beaches", systemImage: "sun.max.fill")
                }
                .tag(1)

            FoodListView()
                .tabItem {
                    Label("Food", systemImage: "fork.knife")
                }
                .tag(2)

            DealsListView()
                .tabItem {
                    Label("Deals", systemImage: "tag")
                }
                .tag(3)

            MapsListView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(4)
        }
        .onOpenURL { url in
            ReferralManager.shared.saveReferrerIfPresent(from: url)
        }
    }
}
