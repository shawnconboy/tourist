import SwiftUI
import MapKit

struct PlaceDetailView: View {
    let place: Place

    @State private var region: MKCoordinateRegion

    init(place: Place) {
        self.place = place
        _region = State(initialValue: MKCoordinateRegion(
            center: place.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Image
                Image(place.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 240)
                    .clipped()
                    .cornerRadius(12)

                // Title + Subtitle
                Text(place.name)
                    .font(.title)
                    .fontWeight(.bold)

                Text(place.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                // Business Hours
                if let hours = place.hours, !hours.isEmpty {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.accentColor)
                        Text("Hours: ")
                            .fontWeight(.semibold)
                        Text(hours)
                    }
                    .font(.subheadline)
                }

                // Phone
                if let phone = place.phone {
                    Button(action: {
                        if let url = URL(string: "tel://\(phone)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Label("Call", systemImage: "phone.fill")
                            .font(.body)
                    }
                }

                // Deal
                if place.dealAvailable == true {
                    HStack {
                        Image(systemName: "tag.fill")
                        Text("Deal available!")
                            .fontWeight(.medium)
                    }
                    .padding(8)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }

                // Map
                Map(initialPosition: .region(region)) {
                    Marker(place.name, coordinate: place.coordinate)
                }
                .frame(height: 200)
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle(place.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
