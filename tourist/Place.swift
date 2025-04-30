import Foundation
import CoreLocation

struct Place: Identifiable, Codable {
    let hours: String?
    let id: String
    let name: String
    let subtitle: String
    let imageName: String
    let category: String
    let type: String?           // For filtering by food type
    let latitude: Double
    let longitude: Double
    let phone: String?          // For call button
    let dealAvailable: Bool?    // For visual deal tags
    let featured: Bool?         // For sorting or highlighting

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
