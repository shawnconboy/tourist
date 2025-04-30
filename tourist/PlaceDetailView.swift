import SwiftUI
import MapKit

struct PlaceDetailView: View {
    let place: Place

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
                VStack(alignment: .leading, spacing: 4) {
                    Text(place.name)
                        .font(.title)
                        .fontWeight(.bold)

                    Text(place.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    // Business Hours
                    if let hours = place.hours, !hours.isEmpty {
                        HStack(alignment: .center, spacing: 6) {
                            Image(systemName: "clock")
                                .foregroundColor(.accentColor)
                            Text("Hours: ")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text(hours)
                                .font(.subheadline)
                        }
                        .padding(.top, 6)
                    }
                }

                // Phone and Deal (if available)
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

                if place.dealAvailable == true {
                    HStack {
                        Image(systemName: "tag.fill")
                            .foregroundColor(.white)
                        Text("Deal available!")
                            .fontWeight(.medium)
                    }
                    .padding(8)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }

                // Map Preview using MapAnnotation
                Map(coordinateRegion: .constant(MKCoordinateRegion(
                    center: place.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )), annotationItems: [place]) { item in
                    MapAnnotation(coordinate: item.coordinate) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .imageScale(.large)
                    }
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
