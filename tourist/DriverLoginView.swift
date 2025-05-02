import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct DriverLoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isLoggedIn = false
    @State private var currentDriver: DriverStats?

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Driver Login")
                    .font(.largeTitle)
                    .bold()

                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)

                Button("Log In") {
                    logInDriver()
                }
                .buttonStyle(.borderedProminent)

                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }

                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $isLoggedIn) {
                if let driver = currentDriver {
                    DriverDashboardView(driver: driver)
                } else {
                    ProgressView("Loading...")
                }
            }
        }
    }

    func logInDriver() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = "Login failed: \(error.localizedDescription)"
            } else if let user = result?.user {
                fetchDriverData(for: user.uid)
            }
        }
    }

    func fetchDriverData(for uid: String) {
        Firestore.firestore().collection("drivers").document(uid).getDocument { snapshot, error in
            if let data = snapshot?.data() {
                let driver = DriverStats(
                    id: snapshot?.documentID ?? uid,
                    name: data["name"] as? String ?? "(No name)",
                    referrals: data["referrals"] as? Int ?? 0,
                    redemptions: data["redemptions"] as? Int ?? 0
                )
                self.currentDriver = driver
                self.isLoggedIn = true
            } else {
                self.errorMessage = "Driver data not found."
            }
        }
    }
}
