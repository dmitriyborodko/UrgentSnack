import Foundation

struct VenueListResponse: Decodable {

    // MARK: - Nested Types
    
    struct Response: Decodable {
        let venues: [Venue]
    }

    // MARK: - Instance Properties

    let response: Response
}
