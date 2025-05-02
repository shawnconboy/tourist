import SwiftUI
import FirebaseFirestore

struct DriverListSheet: View {
    let drivers: [DriverStats]
    var onUpdate: () -> Void
    var onDelete: (String) -> Void
    var onLongPressQR: (String) -> Void

    @State private var editingDriver: DriverStats?

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List {
                if drivers.isEmpty {
                    Text("No drivers found.")
                        .foregroundColor(.gray)
                        .italic()
                } else {
                    ForEach(drivers) { driver in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(driver.name)
                                .font(.headline)

                            HStack {
                                Text("Referrals: \(driver.referrals)")
                                Spacer()
                                Text("Redemptions: \(driver.redemptions)")
                            }
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        }
                        .padding(.vertical, 6)
                        .contentShape(Rectangle())
                        .onLongPressGesture {
                            onLongPressQR(driver.id)
                        }
                        .swipeActions(edge: .trailing) {
                            Button {
                                editingDriver = driver
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)

                            Button(role: .destructive) {
                                onDelete(driver.id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .navigationTitle("All Drivers")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(item: $editingDriver) { driver in
            NavigationView {
                EditDriverFormView(driver: driver) { newFirst, newLast, newID in
                    let fullName = "\(newFirst) \(newLast)"

                    if newID == driver.id {
                        Firestore.firestore().collection("drivers").document(driver.id).updateData([
                            "name": fullName
                        ]) { _ in
                            editingDriver = nil
                            onUpdate()
                        }
                    } else {
                        Firestore.firestore().collection("drivers").document(newID).setData([
                            "name": fullName,
                            "referrals": driver.referrals,
                            "redemptions": driver.redemptions
                        ]) { error in
                            if error == nil {
                                Firestore.firestore().collection("drivers").document(driver.id).delete { _ in
                                    editingDriver = nil
                                    onUpdate()
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Edit Driver")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            editingDriver = nil
                        }
                    }
                }
            }
        }
    }
}
