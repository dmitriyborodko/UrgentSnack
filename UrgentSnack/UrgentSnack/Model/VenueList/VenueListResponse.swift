import Foundation

struct VenueListResponse: Decodable {
    struct Response: Decodable {
        let venues: [Venue]
    }

    let response: Response
}
