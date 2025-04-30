import SwiftUI

struct PlaceRow: View {
    let place: Place

    var body: some View {
        HStack(spacing: 16) {
            Image(place.imageName)
                .resizable()
                .frame(width: 60, height: 60)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(place.name)
                    .font(.headline)
                Text(place.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(.horizontal, 16) // ✅ Add horizontal padding
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}
