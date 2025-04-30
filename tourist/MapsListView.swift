import SwiftUI
import MapKit

struct MapListView: View {
    @State private var places: [Place] = []
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 32.7765, longitude: -79.9311),
        span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
    )

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                ZStack {
                    Color.clear // Ensure ZStack fills area

                    Map(initialPosition: .region(region)) {
                        ForEach(places) { place in
                            Marker(place.name, coordinate: place.coordinate)
                        }
                    }
                    .frame(width: geo.size.width, height: geo.size.height * 0.85)
                    .clipped()
                }

                List {
                    ForEach(places) { place in
                        NavigationLink(destination: PlaceDetailView(place: place)) {
                            PlaceRow(place: place)
                        }
                        .listRowInsets(EdgeInsets())
                    }
                }
                .listStyle(PlainListStyle())
            }
            .edgesIgnoringSafeArea(.top)
        }
        .navigationTitle("Map")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { loadPlaces() }
    }

    func loadPlaces() {
        if let url = Bundle.main.url(forResource: "allPlaces", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode([Place].self, from: data) {
            self.places = decoded
        }
    }
}
