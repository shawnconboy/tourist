import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct DriverDashboardView: View {
    @Environment(\.dismiss) var dismiss
    @State private var referralCount = 0
    @State private var email = Auth.auth().currentUser?.email ?? "Driver"
    @State private var db = Firestore.firestore()

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Welcome, \(email)")
                    .font(.headline)

                VStack(spacing: 8) {
                    Text("Referral QR Code")
                        .font(.subheadline)
                    QRCodeView(text: "https://yourapp.page.link/?ref=\(referralID)")
                        .frame(width: 200, height: 200)
                }

                VStack {
                    Text("Referrals: \(referralCount)")
                        .font(.title2)
                        .bold()
                }

                Button("Log Out") {
                    try? Auth.auth().signOut()
                    dismiss()
                }
                .foregroundColor(.red)
                .padding(.top, 32)

                Spacer()
            }
            .padding()
            .navigationTitle("Driver Dashboard")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                loadReferralStats()
            }
        }
    }

    var referralID: String {
        return email.components(separatedBy: "@").first ?? "driver"
    }

    func loadReferralStats() {
        let docRef = db.collection("drivers").document(referralID)

        docRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                self.referralCount = data?["referrals"] as? Int ?? 0
            } else {
                print("No driver doc found or error: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}
