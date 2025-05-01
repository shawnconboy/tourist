import SwiftUI
import FirebaseFirestore
import CoreImage.CIFilterBuiltins

struct SettingsView: View {
    @State private var showLoginSheet = false
    @AppStorage("isAdmin") private var isAdmin = false

    @State private var drivers: [DriverStats] = []

    @State private var showAddDriverSheet = false
    @State private var newDriverName = ""

    @State private var showDriverList = false
    @State private var editingDriverID: String?
    @State private var updatedName = ""

    @State private var showQRDialog = false
    @State private var qrDriverID = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("App Info")) {
                    Text("Version 1.0")
                }

                Section(header: Text("Admin Access")) {
                    if isAdmin {
                        Text("✅ Admin Access Granted")
                            .foregroundColor(.green)

                        Button("Logout Admin") {
                            isAdmin = false
                        }
                        .foregroundColor(.red)

                        Button("Enter New Driver") {
                            showAddDriverSheet = true
                        }

                        Button(showDriverList ? "Hide Drivers" : "See Drivers") {
                            showDriverList.toggle()
                        }

                        if showDriverList {
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

                                    HStack {
                                        Button("Edit Name") {
                                            editingDriverID = driver.id
                                            updatedName = driver.name
                                        }
                                        .font(.caption)

                                        Spacer()

                                        Button("Delete") {
                                            deleteDriver(driverID: driver.id)
                                        }
                                        .foregroundColor(.red)
                                        .font(.caption)
                                    }
                                }
                                .padding(.vertical, 8)
                                .contentShape(Rectangle())
                                .onLongPressGesture {
                                    qrDriverID = driver.id
                                    showQRDialog = true
                                }
                            }
                        }
                    } else {
                        Button("Login as Admin") {
                            showLoginSheet = true
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                if isAdmin {
                    fetchDrivers()
                }
            }
            .sheet(isPresented: $showAddDriverSheet) {
                NavigationView {
                    VStack(spacing: 24) {
                        Text("Enter New Driver")
                            .font(.title2)
                            .bold()
                            .padding(.top)

                        TextField("Driver Name", text: $newDriverName)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(red: 0.0, green: 0.18, blue: 0.38), lineWidth: 1.5)
                            )
                            .padding(.horizontal)

                        Button(action: {
                            addDriver()
                        }) {
                            Text("Add Driver")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 0.0, green: 0.18, blue: 0.38))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(newDriverName.isEmpty)
                        .padding(.horizontal)

                        Spacer()
                    }
                    .background(Color.white)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                showAddDriverSheet = false
                            }
                        }
                    }
                }
            }


            .confirmationDialog("Referral QR", isPresented: $showQRDialog) {
                Button("Copy Link") {
                    UIPasteboard.general.string = "https://shawnconboy.github.io/touristapp-referral/?ref=\(qrDriverID)"
                }
            } message: {
                VStack(spacing: 12) {
                    Text("Driver: \(qrDriverID)")
                        .font(.headline)
                    QRCodeView(text: "https://shawnconboy.github.io/touristapp-referral/?ref=\(qrDriverID)")
                        .frame(width: 180, height: 180)
                        .padding(.vertical, 8)
                }
            }
        }
    }

    func fetchDrivers() {
        let db = Firestore.firestore()
        db.collection("drivers").getDocuments { snapshot, error in
            if let snapshot = snapshot {
                self.drivers = snapshot.documents.map { doc in
                    let data = doc.data()
                    return DriverStats(
                        id: doc.documentID,
                        name: data["name"] as? String ?? "(No name)",
                        referrals: data["referrals"] as? Int ?? 0,
                        redemptions: data["redemptions"] as? Int ?? 0
                    )
                }
            }
        }
    }

    func addDriver() {
        let db = Firestore.firestore()
        let autoID = UUID().uuidString.prefix(8)

        db.collection("drivers").document(String(autoID)).setData([
            "name": newDriverName,
            "referrals": 0,
            "redemptions": 0
        ]) { error in
            if error == nil {
                fetchDrivers()
                newDriverName = ""
                showAddDriverSheet = false
            }
        }
    }

    func deleteDriver(driverID: String) {
        let db = Firestore.firestore()
        db.collection("drivers").document(driverID).delete { error in
            if error == nil {
                fetchDrivers()
            }
        }
    }

    func updateDriverName(driverID: String, newName: String) {
        let db = Firestore.firestore()
        db.collection("drivers").document(driverID).updateData([
            "name": newName
        ]) { error in
            if error == nil {
                editingDriverID = nil
                fetchDrivers()
            }
        }
    }
}

struct DriverStats: Identifiable {
    let id: String
    let name: String
    let referrals: Int
    let redemptions: Int
}
