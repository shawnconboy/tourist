import SwiftUI
import FirebaseAuth

struct LoginSheetView: View {
    @Binding var showLoginSheet: Bool
    var onSuccess: () -> Void

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""

    @FocusState private var focusedField: Field?

    enum Field {
        case email
        case password
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Admin Login")
                    .font(.title2)
                    .bold()

                // Email Field
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    // Removed .textContentType to prevent autofill interference
                    .focused($focusedField, equals: .email)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .password
                    }
                    .onChange(of: focusedField) { newField in
                        if newField != .email {
                            // Place to add email validation if needed (after focus leaves)
                            print("Finished typing email: \(email)")
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                // Password Field
                SecureField("Password", text: $password)
                    .focused($focusedField, equals: .password)
                    .submitLabel(.go)
                    .onSubmit {
                        login()
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                // Error message if login fails
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                // Login Button
                Button("Login") {
                    login()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .navigationBarItems(trailing: Button("Cancel") {
                showLoginSheet = false
            })
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    focusedField = .email
                }
            }
        }
    }

    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                UserDefaults.standard.set(true, forKey: "isAdmin")
                showLoginSheet = false
                onSuccess()
            }
        }
    }
}
