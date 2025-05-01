import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginSheetView: View {
    @Binding var showLoginSheet: Bool
    var onSuccess: () -> Void = {}

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @AppStorage("isAdmin") private var isAdmin = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Admin Login")
                    .font(.title)

                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)

                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                }

                Button("Login") {
                    login()
                }
                .buttonStyle(.borderedProminent)

                Spacer()
            }
            .padding()
            .navigationBarItems(trailing: Button("Close") {
                showLoginSheet = false
            })
        }
    }

    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }

            guard let user = result?.user else {
                self.errorMessage = "Login failed."
                return
            }

            let db = Firestore.firestore()
            db.collection("admins").document(user.uid).getDocument { doc, err in
                if let doc = doc, doc.exists,
                   let isAdminFlag = doc.data()?["isAdmin"] as? Bool, isAdminFlag == true {
                    print("✅ Admin access granted.")
                    self.isAdmin = true
                    self.showLoginSheet = false
                    self.onSuccess()
                } else {
                    self.errorMessage = "Not authorized as admin."
                }
            }
        }
    }
}
