import Foundation
import CoreLocation

struct Venue {

    // MARK: - Instance Properties
    
    var id: String
    var name: String
    var location: CLLocation
    var details: VenueDetails?
}

extension Venue: Hashable {

    // MARK: - Type Methods

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }

    // MARK: - Instance Properties

    var hashValue: Int { id.hash }

    // MARK: - Instance Methods

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
