import SwiftUI

struct AddDriverFormView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phoneNumber = ""

    @FocusState private var focusedField: Field?

    enum Field {
        case first, last, number
    }

    var onSubmit: (String, String, String) -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Enter New Driver")
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
                    onSubmit(firstName, lastName, digitsOnly(phoneNumber))
                }) {
                    Text("Add Driver")
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
