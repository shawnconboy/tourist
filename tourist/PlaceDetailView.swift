import SwiftUI
import MapKit

struct PlaceDetailView: View {
    let place: Place

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Image
                Image(place.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 240)
                    .clipped()
                    .cornerRadius(16)

                // Title & Subtitle
                VStack(alignment: .leading, spacing: 6) {
                    Text(place.name)
                        .font(.title)
                        .fontWeight(.bold)

                    Text(place.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    // Business Hours
                    if let hours = place.hours, !hours.isEmpty {
                        HStack(spacing: 6) {
                            Image(systemName: "clock")
                                .foregroundColor(.accentColor)
                            Text("Hours:")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text(hours)
                                .font(.subheadline)
                        }
                        .padding(.top, 4)
                    }
                }

                // Phone Button (Optional)
                if let phone = place.phone {
                    Button(action: {
                        if let url = URL(string: "tel://\(phone)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Label("Call", systemImage: "phone.fill")
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                // Deal Badge (Optional)
                if place.dealAvailable == true {
                    HStack {
                        Image(systemName: "tag.fill")
                        Text("Deal available!")
                            .fontWeight(.medium)
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }

                // Map
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
