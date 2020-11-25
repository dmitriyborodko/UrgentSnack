import Foundation

struct VenueListResponse: Decodable {

    struct Response: Decodable {
        var venues: [Venue]
    }

    // MARK: - Instance Properties

    let response: Response
}
