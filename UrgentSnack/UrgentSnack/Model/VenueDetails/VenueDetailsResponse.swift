import Foundation

struct VenueDetailsResponse: Decodable {
    struct Response: Decodable {
        let venue: VenueDetails
    }

    let response: Response
}
