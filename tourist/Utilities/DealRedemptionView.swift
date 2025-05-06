import SwiftUI

struct DealRedemptionView: View {
    @State private var hasRedeemed = false
    var body: some View {
        VStack(spacing: 32) {
            Text("Welcome Passenger!")
                .font(.title)
            if hasRedeemed {
                Text("✅ Deal Redeemed! Thank you!")
            } else {
                Button("Use Deal") {
                    // TODO: Call ReferralManager.shared.redeemDeal(userID: ...)
                    hasRedeemed = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}

#Preview {
    DealRedemptionView()
}
