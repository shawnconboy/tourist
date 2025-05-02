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

    @State private var showEditSheet = false
    @State private var editingDriverID: String?
    @State private var updatedName = ""

    @State private var showQRDialog = false
    @State private var qrDriverID = ""

    @State private var showToast = false
    @State private var toastMessage = ""

    var body: some View {
        NavigationView {
            ZStack {
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
                                List {
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
                                            qrDriverID = driver.id
                                            showQRDialog = true
                                        }
                                        .swipeActions(edge: .trailing) {
                                            Button {
                                                editingDriverID = driver.id
                                                updatedName = driver.name
                                                showEditSheet = true
                                            } label: {
                                                Label("Edit", systemImage: "pencil")
                                            }
                                            .tint(.blue)

                                            Button(role: .destructive) {
                                                deleteDriverByID(driverID: driver.id)
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
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

                // Toast Message
                if showToast {
                    VStack {
                        Spacer()
                        Text(toastMessage)
                            .font(.subheadline)
                            .padding()
                            .background(Color.black.opacity(0.85))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .padding(.bottom, 20)
                    }
                    .animation(.easeInOut(duration: 0.3), value: showToast)
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                if isAdmin {
                    fetchDrivers()
                }
            }

            .sheet(isPresented: $showLoginSheet) {
                LoginSheetView(showLoginSheet: $showLoginSheet) {
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
                                    .stroke(Color.blue, lineWidth: 1.5)
                            )
                            .padding(.horizontal)

                        Button("Add Driver") {
                            addDriver()
                        }
                        .disabled(newDriverName.isEmpty)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)

                        Spacer()
                    }
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

            .sheet(isPresented: $showEditSheet) {
                NavigationView {
                    VStack(spacing: 24) {
                        Text("Edit Driver Name")
                            .font(.title2)
                            .bold()
                            .padding(.top)

                        TextField("New Name", text: $updatedName)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 1.5)
                            )
                            .padding(.horizontal)

                        Button("Save") {
                            if let id = editingDriverID {
                                updateDriverName(driverID: id, newName: updatedName)
                            }
                        }
                        .disabled(updatedName.isEmpty)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)

                        Spacer()
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                showEditSheet = false
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

    // MARK: - Firestore Actions

    func fetchDrivers() {
        Firestore.firestore().collection("drivers").getDocuments { snapshot, error in
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
        let id = String(UUID().uuidString.prefix(8))
        Firestore.firestore().collection("drivers").document(id).setData([
            "name": newDriverName,
            "referrals": 0,
            "redemptions": 0
        ]) { error in
            if error == nil {
                fetchDrivers()
                newDriverName = ""
                showAddDriverSheet = false
                showToastMessage("Driver added!")
            }
        }
    }

    func deleteDriverByID(driverID: String) {
        Firestore.firestore().collection("drivers").document(driverID).delete { _ in
            fetchDrivers()
            showToastMessage("Driver deleted")
        }
    }

    func updateDriverName(driverID: String, newName: String) {
        Firestore.firestore().collection("drivers").document(driverID).updateData([
            "name": newName
        ]) { error in
            if error == nil {
                showEditSheet = false
                editingDriverID = nil
                fetchDrivers()
                showToastMessage("Driver updated")
            }
        }
    }

    func showToastMessage(_ message: String) {
        toastMessage = message
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                showToast = false
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
