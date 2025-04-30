import SwiftUI

struct FoodListView: View {
    @State private var allPlaces: [Place] = []
    
    var foodPlaces: [Place] {
        allPlaces.filter { $0.category == "Food" }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(foodPlaces) { place in
                    NavigationLink(destination: PlaceDetailView(place: place)) {
                        PlaceRow(place: place) // No extra padding, background, or shadows
                    }
                }
            }
            .navigationTitle("Food & Drink")
            .onAppear(perform: loadPlaces) // Calls loadPlaces when the view appears
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
