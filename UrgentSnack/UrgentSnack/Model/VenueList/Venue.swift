import Foundation
import CoreLocation

struct Venue: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case location
    }

    struct Location: Decodable {
        private enum CodingKeys: String, CodingKey {
            case latitude = "lat"
            case longitude = "lng"
        }

        let latitude: Double
        let longitude: Double
    }
    
    var id: String
    var name: String
    var location: Location
}

extension Venue: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
}

extension Venue: Hashable {
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
