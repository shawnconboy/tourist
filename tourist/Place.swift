import Foundation
import CoreLocation

struct Place: Identifiable, Codable {
    let id: String
    let name: String
    let subtitle: String
    let imageName: String
    let category: String
    let type: String?           // Optional: e.g., Southern, Sushi
    let latitude: Double
    let longitude: Double
    let hours: String?          // Optional: “9am - 10pm”
    let phone: String?          // Optional: tap to call
    let dealAvailable: Bool?    // Optional: Show deal banner
    let featured: Bool?         // Optional: Use in homepage

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
