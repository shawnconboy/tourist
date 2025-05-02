import SwiftUI
import FirebaseFirestore

struct EditDriverFormView: View {
    @State private var firstName: String
    @State private var lastName: String
    @State private var phoneNumber: String

    var originalID: String
    var onSave: (String, String, String) -> Void

    @FocusState private var focusedField: Field?

    enum Field {
        case first, last, number
    }

    init(driver: DriverStats, onSave: @escaping (String, String, String) -> Void) {
        let nameParts = driver.name.split(separator: " ")
        _firstName = State(initialValue: nameParts.first.map(String.init) ?? "")
        _lastName = State(initialValue: nameParts.dropFirst().joined(separator: " "))
        _phoneNumber = State(initialValue: driver.id)
        self.originalID = driver.id
        self.onSave = onSave
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Edit Driver Info")
                    .font(.title2)
                    .bold()
                    .padding(.top)

                VStack(spacing: 16) {
                    TextField("First Name", text: $firstName)
                        .textContentType(.givenName)
                        .padding()
                        .background(Color(.systemGray6))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(borderColor(firstName), lineWidth: 1))
                        .cornerRadius(10)
                        .focused($focusedField, equals: .first)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .last }

                    TextField("Last Name", text: $lastName)
                        .textContentType(.familyName)
                        .padding()
                        .background(Color(.systemGray6))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(borderColor(lastName), lineWidth: 1))
                        .cornerRadius(10)
                        .focused($focusedField, equals: .last)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .number }

                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.numberPad)
                        .textContentType(.telephoneNumber)
                        .padding()
                        .background(Color(.systemGray6))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(borderColor(phoneNumber), lineWidth: 1))
                        .cornerRadius(10)
                        .focused($focusedField, equals: .number)
                }
                .padding(.horizontal)

                Button(action: {
                    onSave(firstName, lastName, digitsOnly(phoneNumber))
                }) {
                    Text("Save Changes")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(firstName.isEmpty || lastName.isEmpty || phoneNumber.isEmpty)

                Spacer()
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }

    func borderColor(_ value: String) -> Color {
        value.isEmpty ? Color.gray.opacity(0.4) : Color.gray.opacity(0.8)
    }

    func digitsOnly(_ input: String) -> String {
        input.filter { $0.isWholeNumber }
    }
}
