import SwiftUI

struct FilteredFoodListView: View {
    let tag: String
    let allPlaces: [Place]

    var filteredPlaces: [Place] {
        allPlaces.filter {
            $0.category == "Food" && ($0.tags?.contains(tag) == true)
        }
    }

    var body: some View {
        List {
            ForEach(filteredPlaces) { place in
                NavigationLink(destination: PlaceDetailView(place: place)) {
                    PlaceRow(place: place)
                }
            }
        }
        .navigationTitle(tag.capitalized)
    }
}
