import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            BeachListView()
                .tabItem {
                    Label("Beaches", systemImage: "sun.max.fill")
                }
                .tag(1)

            FoodListView()
                .tabItem {
                    Label("Food & Drink", systemImage: "fork.knife")
                }
                .tag(2)

            ThingsListView()
                .tabItem {
                    Label("Things To Do", systemImage: "star.fill")
                }
                .tag(3)

            DealsListView()
                .tabItem {
                    Label("Deals", systemImage: "flame.fill")
                }
                .tag(4)

            MapListView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
                .tag(5)
        }
    }
}
