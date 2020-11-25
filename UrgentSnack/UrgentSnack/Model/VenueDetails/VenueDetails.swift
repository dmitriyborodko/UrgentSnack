import Foundation

struct VenueDetails: Decodable {

    // MARK: - Nested Types

    struct BestPhoto: Decodable {
        let prefix: String
        let suffix: String
        let width: Int
        let height: Int

        var asString: String { "\(prefix + width.asString)x\(height.asString + suffix)" }
    }

    struct Likes: Decodable {
        let summary: String
    }

    // MARK: - Instance Properties

    let id: String
    let name: String
    let likes: Likes?
    let rating: Double?
    let description: String?
    let bestPhoto: BestPhoto
}

private extension Int {
    var asString: String { String(self) }
}
