import SwiftUI

struct DealsListView: View {
    @State private var places: [Place] = []

    var body: some View {
        NavigationView {
            List {
                ForEach(places.filter { $0.category == "Deals" }) { place in
                    NavigationLink(destination: PlaceDetailView(place: place)) {
                        PlaceRow(place: place)
                    }
                }
            }
            .navigationTitle("Deals & Promos")
            .onAppear { loadPlaces() }
        }
    }

    func loadPlaces() {
        if let url = Bundle.main.url(forResource: "allPlaces", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode([Place].self, from: data) {
            self.places = decoded
        }
    }
}
