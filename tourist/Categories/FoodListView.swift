import SwiftUI

struct FoodListView: View {
    @State private var allPlaces: [Place] = []
    @State private var selectedFoodType: String = "All"

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

    let foodTypes = ["All", "American", "Seafood", "Chinese", "Southern", "Barbecue", "Mexican", "Italian", "Breakfast"]

    var filteredPlaces: [Place] {
        if selectedFoodType == "All" {
            return []
        } else {
            return allPlaces.filter {
                $0.tags?.contains(where: { $0.caseInsensitiveCompare(selectedFoodType) == .orderedSame }) ?? false
            }
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {

                    // Filter Chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(foodTypes, id: \.self) { type in
                                Button(action: {
                                    selectedFoodType = type
                                }) {
                                    Text(type)
                                        .font(.subheadline)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(selectedFoodType == type ? Color.accentColor : Color(.systemGray5))
                                        .foregroundColor(selectedFoodType == type ? .white : .primary)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    if selectedFoodType == "All" {
                        // Original 6 Tiles
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
                    } else {
                        // Filtered List
                        VStack(spacing: 12) {
                            ForEach(filteredPlaces) { place in
                                NavigationLink(destination: PlaceDetailView(place: place)) {
                                    PlaceRow(place: place)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
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
