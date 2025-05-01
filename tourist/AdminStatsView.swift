import SwiftUI
import FirebaseFirestore

struct AdminStatsView: View {
    @State private var drivers: [Driver] = []
    @State private var isLoading = true
    private let db = Firestore.firestore()

    var body: some View {
        NavigationView {
            List(drivers) { driver in
                VStack(alignment: .leading, spacing: 6) {
                    Text("Driver ID: \(driver.id)")
                        .font(.headline)
                    HStack {
                        Text("Referrals: \(driver.referrals)")
                        Spacer()
                        Text("Redemptions: \(driver.redemptions)")
                    }
                    .font(.subheadline)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Driver Stats")
            .onAppear { fetchDrivers() }
        }
    }

    func fetchDrivers() {
        db.collection("drivers").getDocuments { snapshot, error in
            if let error = error {
                print("Error loading drivers: \(error.localizedDescription)")
                return
            }

            self.drivers = snapshot?.documents.map { doc in
                let data = doc.data()
                return Driver(
                    id: doc.documentID,
                    referrals: data["referrals"] as? Int ?? 0,
                    redemptions: data["redemptions"] as? Int ?? 0
                )
            } ?? []
            self.isLoading = false
        }
    }
}

struct Driver: Identifiable {
    let id: String
    let referrals: Int
    let redemptions: Int
}
