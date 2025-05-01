import SwiftUI

struct EventDetailView: View {
    let event: Event

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Optional: Event image here later

                Text(event.title)
                    .font(.title)
                    .fontWeight(.bold)

                HStack {
                    Label(event.date, systemImage: "calendar")
                    Spacer()
                    Label(event.price, systemImage: "creditcard")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)

                Label(event.location, systemImage: "mappin.and.ellipse")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Divider()

                Text("More details about this event could go here. You could describe the vibe, schedule, rules, or parking.")
                    .font(.body)
            }
            .padding()
        }
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
