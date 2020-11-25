import Foundation

struct VenueDetails: Decodable {

    // MARK: - Nested Types

    struct Contact: Decodable {
        let phone: String
        let formattedPhone: String
    }

    struct Location: Decodable {
        private enum CodingKeys: String, CodingKey {
            case latitude = "lat"
            case longitude = "lng"
            case formattedAddress
        }

        let latitude: Double
        let longitude: Double
        let formattedAddress: String
    }

    struct BestPhoto: Decodable {
        var prefix: String
        var suffix: String
    }

    struct Likes: Decodable {
        let summary: String
    }

    // MARK: - Instance Properties

    let id: String
    let name: String
    let contact: Contact
    let location: Location
    let likes: Likes
    let rating: Double
    let ratingColor: String
    let description: String
    let bestPhoto: BestPhoto
}
