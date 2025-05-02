import SwiftUI
import FirebaseFirestore
import CoreImage.CIFilterBuiltins

struct SettingsView: View {
    @State private var showLoginSheet = false
    @AppStorage("isAdmin") private var isAdmin = false

    @State private var drivers: [DriverStats] = []
    @State private var showAddDriverSheet = false

    @State private var showEditSheet = false
    @State private var editingDriverID: String?

    @State private var showQRDialog = false
    @State private var qrDriverID = ""

    @State private var showToast = false
    @State private var toastMessage = ""

    @State private var showDriverDashboard = false
    @State private var showDriverListSheet = false

    @State private var currentDriver = DriverStats(id: "sample123", name: "Sample Driver", referrals: 8, redemptions: 3)

    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section(header: Text("Driver Access")) {
                        Button("Track Your Bonuses") {
                            showDriverDashboard = true

                            let testID = "8642223333"
                            Firestore.firestore().collection("drivers").document(testID).updateData([
                                "referrals": FieldValue.increment(Int64(1))
                            ]) { error in
                                if let error = error {
                                    print("❌ Test failed: \(error.localizedDescription)")
                                } else {
                                    print("✅ Test referral added")
                                    fetchDrivers()
                                }
                            }
                        }
                    }

                    Section(header: Text("Admin Access")) {
                        if isAdmin {
                            Text("\u{2705} Admin Access Granted")
                                .foregroundColor(.green)

                            Button("Logout Admin") {
                                isAdmin = false
                            }
                            .foregroundColor(.red)

                            Button("Enter New Driver") {
                                showAddDriverSheet = true
                            }

                            Button("See Drivers") {
                                fetchDrivers()
                                showDriverListSheet = true
                            }
                        } else {
                            Button("Login as Admin") {
                                showLoginSheet = true
                            }
                        }
                    }

                    Section(header: Text("App Info")) {
                        Text("Version 1.0")
                    }
                }

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
                    AddDriverFormView { first, last, number in
                        let fullName = "\(first) \(last)"
                        let id = number
                        Firestore.firestore().collection("drivers").document(id).setData([
                            "name": fullName,
                            "referrals": 0,
                            "redemptions": 0
                        ]) { error in
                            if error == nil {
                                fetchDrivers()
                                showAddDriverSheet = false
                                showToastMessage("Driver added!")
                            }
                        }
                    }
                    .navigationTitle("Add New Driver")
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
                if let id = editingDriverID, let driver = drivers.first(where: { $0.id == id }) {
                    NavigationView {
                        EditDriverFormView(driver: driver) { newFirst, newLast, newID in
                            let fullName = "\(newFirst) \(newLast)"

                            if newID == driver.id {
                                updateDriverName(driverID: driver.id, newName: fullName)
                            } else {
                                Firestore.firestore().collection("drivers").document(newID).setData([
                                    "name": fullName,
                                    "referrals": driver.referrals,
                                    "redemptions": driver.redemptions
                                ]) { error in
                                    if error == nil {
                                        deleteDriverByID(driverID: driver.id)
                                        fetchDrivers()
                                        showToastMessage("Driver ID updated")
                                        showEditSheet = false
                                    }
                                }
                            }
                        }
                        .navigationTitle("Edit Driver")
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
            }

            .confirmationDialog("Referral QR", isPresented: $showQRDialog) {
                Button("Copy Link") {
                    UIPasteboard.general.string = "https://shawnconboy.github.io/touristapp-referral/?ref=\(qrDriverID)"
                }
            } message: {
                VStack(spacing: 12) {
                    Text("Driver: \(qrDriverID)")
                        .font(.headline)

                    let link = "https://shawnconboy.github.io/touristapp-referral/?ref=\(qrDriverID)"
                    if let image = generateQRCodeImage(link) {
                        Image(uiImage: image)
                            .resizable()
                            .interpolation(.none)
                            .frame(width: 180, height: 180)
                            .padding(.vertical, 8)

                        ShareLink(item: Image(uiImage: image), preview: SharePreview("Driver QR", image: Image(uiImage: image))) {
                            Label("Share QR Code", systemImage: "square.and.arrow.up")
                        }
                    } else {
                        Text("Unable to generate QR")
                            .foregroundColor(.red)
                    }
                }
            }

            .sheet(isPresented: $showDriverDashboard) {
                DriverDashboardView(driver: currentDriver)
            }

            .sheet(isPresented: $showDriverListSheet) {
                DriverListSheet(
                    drivers: drivers,
                    onUpdate: {
                        fetchDrivers()
                        showToastMessage("Driver updated")
                    },
                    onDelete: { id in
                        deleteDriverByID(driverID: id)
                    },
                    onLongPressQR: { id in
                        qrDriverID = id
                        showQRDialog = true
                    }
                )
            }
        }
    }

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

    func generateQRCodeImage(_ string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(Data(string.utf8), forKey: "inputMessage")

        if let outputImage = filter.outputImage {
            let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
            if let cgimg = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return nil
    }
}

struct DriverStats: Identifiable {
    let id: String
    let name: String
    let referrals: Int
    let redemptions: Int
}
