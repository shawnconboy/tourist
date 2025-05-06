import Foundation
import CoreLocation

struct Place: Identifiable, Codable {
    let id: String
    let name: String
    let subtitle: String
    let imageName: String
    let category: String
    let type: String?
    let address: String?
    let phone: String?
    let dealAvailable: Bool?
    let featured: Bool?
    let hours: String?
    let tags: [String]?

    // Optional location support (some bars may have no coordinates)
    let latitude: Double?
    let longitude: Double?

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: latitude ?? 0.0,
            longitude: longitude ?? 0.0
        )
    }
}
