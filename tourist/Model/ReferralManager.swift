import Foundation
import FirebaseFirestore
import FirebaseAuth

class ReferralManager: ObservableObject {
    static let shared = ReferralManager()

    private let userDefaultsReferrerKey = "referrerID"
    private let userDefaultsInstallDateKey = "installDate"
    private let userDefaultsInstallLoggedKey = "hasLoggedInstall"

    // MARK: - Capture referral from URL
    func saveReferrerIfPresent(from url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let ref = components.queryItems?.first(where: { $0.name == "ref" })?.value else { return }

        UserDefaults.standard.setValue(ref, forKey: userDefaultsReferrerKey)

        if UserDefaults.standard.string(forKey: userDefaultsInstallDateKey) == nil {
            let date = ISO8601DateFormatter().string(from: Date())
            UserDefaults.standard.setValue(date, forKey: userDefaultsInstallDateKey)
        }

        print("✅ Referrer saved: \(ref)")
    }

    // MARK: - Public accessors
    func getReferrer() -> String? {
        UserDefaults.standard.string(forKey: userDefaultsReferrerKey)
    }

    func getInstallDate() -> String? {
        UserDefaults.standard.string(forKey: userDefaultsInstallDateKey)
    }

    func hasLoggedInstall() -> Bool {
        UserDefaults.standard.bool(forKey: userDefaultsInstallLoggedKey)
    }

    // MARK: - One-time install logging
    func logInstallToFirestore(userID: String) {
        if hasLoggedInstall() {
            print("ℹ️ Install already logged for this device.")
            return
        }

        let db = Firestore.firestore()
        let referrerID = getReferrer() ?? "unknown"
        let installDate = getInstallDate() ?? ISO8601DateFormatter().string(from: Date())

        // Write user install record
        db.collection("users").document(userID).setData([
            "referrer": referrerID,
            "installDate": installDate,
            "hasRedeemed": false
        ]) { error in
            if let error = error {
                print("❌ Error logging install: \(error.localizedDescription)")
                return
            }

            print("✅ User install logged.")

            if referrerID != "unknown" {
                // Increment driver's referral count
                db.collection("drivers").document(referrerID).updateData([
                    "referrals": FieldValue.increment(Int64(1))
                ]) { error in
                    if error != nil {
                        print("⚠️ Error updating driver referral count.")
                    } else {
                        print("✅ Driver referral count incremented.")
                    }
                }
            }

            // Mark install as logged
            UserDefaults.standard.set(true, forKey: self.userDefaultsInstallLoggedKey)
        }
    }

    // MARK: - Deal Redemption
    func redeemDeal(userID: String) {
        let db = Firestore.firestore()

        // Update user record
        db.collection("users").document(userID).updateData([
            "hasRedeemed": true
        ])

        // Credit referrer if one exists
        if let referrerID = getReferrer() {
            db.collection("drivers").document(referrerID).updateData([
                "redemptions": FieldValue.increment(Int64(1))
            ])
        }
    }
}
