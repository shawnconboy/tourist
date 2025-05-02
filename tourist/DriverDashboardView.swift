import SwiftUI

struct DriverDashboardView: View {
    let driver: DriverStats

    // Simulated payout history (replace with Firestore later)
    let payoutHistory: [PayoutRecord] = [
        PayoutRecord(date: "Apr 15, 2025", amount: 50, reason: "10 referrals", status: "Paid"),
        PayoutRecord(date: "Mar 20, 2025", amount: 25, reason: "5 redemptions", status: "Paid")
    ]

    var referralThreshold = 10
    var redemptionThreshold = 5

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Driver Dashboard")
                        .font(.title)
                        .bold()

                    VStack(spacing: 8) {
                        Text(driver.name)
                            .font(.title3)
                        Text("ID: \(driver.id)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    Divider()

                    VStack(spacing: 16) {
                        // Referral Info
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Referrals: \(driver.referrals) / \(referralThreshold)")
                                .bold()
                            ProgressView(value: Double(driver.referrals), total: Double(referralThreshold))
                        }

                        // Redemption Info
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Redemptions: \(driver.redemptions) / \(redemptionThreshold)")
                                .bold()
                            ProgressView(value: Double(driver.redemptions), total: Double(redemptionThreshold))
                        }

                        // Eligibility
                        VStack {
                            if isEligible {
                                Text("🎉 You're eligible for your bonus!")
                                    .font(.headline)
                                    .foregroundColor(.green)
                            } else {
                                Text("Keep going! Reach the goal for a payout.")
                                    .font(.subheadline)
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)

                    // Payout History
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Payout History")
                            .font(.headline)

                        ForEach(payoutHistory) { record in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(record.date)
                                    Spacer()
                                    Text("$\(record.amount, specifier: "%.2f")")
                                }
                                .font(.subheadline)

                                Text(record.reason)
                                    .font(.caption)

                                Text("Status: \(record.status)")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 1)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle("Your Bonuses")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    var isEligible: Bool {
        driver.referrals >= referralThreshold || driver.redemptions >= redemptionThreshold
    }
}

struct PayoutRecord: Identifiable {
    let id = UUID()
    let date: String
    let amount: Double
    let reason: String
    let status: String
}
