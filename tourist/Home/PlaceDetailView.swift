import SwiftUI

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

                // Address + Map Button
                if let address = place.address {
                    Label(address, systemImage: "mappin.and.ellipse")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Button(action: {
                        if let url = URL(string: "http://maps.apple.com/?address=\(address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Label("Open in Maps", systemImage: "map")
                    }
                    .padding(.top, 4)
                }
            }
            .padding()
        }
        .navigationTitle(place.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            NotificationCenter.default.post(name: .didNavigateToPlace, object: nil)
        }
    }
}
