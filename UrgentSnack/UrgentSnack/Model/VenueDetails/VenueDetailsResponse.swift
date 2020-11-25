import Foundation

struct VenueDetailsResponse: Decodable {

    // MARK: - Nested Types

    struct Response: Decodable {
        let venue: VenueDetails
    }

    // MARK: - Instance Properties

    let response: Response
}
