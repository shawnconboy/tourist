import SwiftUI

struct FoodListView: View {
    @State private var allPlaces: [Place] = []

    struct FoodShortcut: Hashable {
        let title: String
        let icon: String
        let color: Color
        let category: String

        static let all: [FoodShortcut] = [
            FoodShortcut(title: "Breakfast", icon: "cup.and.saucer.fill", color: .orange, category: "breakfast"),
            FoodShortcut(title: "Restaurants", icon: "fork.knife", color: .blue, category: "restaurant"),
            FoodShortcut(title: "Bars", icon: "wineglass.fill", color: .purple, category: "bar"),
            FoodShortcut(title: "Seafood", icon: "fish.fill", color: .teal, category: "seafood"),
            FoodShortcut(title: "Outdoor", icon: "leaf.fill", color: .green, category: "outdoor"),
            FoodShortcut(title: "Trending", icon: "flame.fill", color: .red, category: "trending")
        ]
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 16)], spacing: 16) {
                    ForEach(FoodShortcut.all, id: \.self) { shortcut in
                        NavigationLink(destination: FilteredFoodListView(tag: shortcut.category, allPlaces: allPlaces)) {
                            VStack(spacing: 10) {
                                Image(systemName: shortcut.icon)
                                    .font(.system(size: 28))
                                    .foregroundColor(.white)
                                    .frame(width: 52, height: 52)
                                    .background(shortcut.color)
                                    .clipShape(Circle())

                                Text(shortcut.title)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .frame(width: 80)
                            }
                            .padding()
                            .frame(width: 100, height: 120)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Food & Drink")
            .onAppear(perform: loadPlaces)
        }
    }

    func loadPlaces() {
        if let url = Bundle.main.url(forResource: "allPlaces", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode([Place].self, from: data) {
            self.allPlaces = decoded
        }
    }
}
