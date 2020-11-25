import Foundation
import UIKit

struct BestPhotoRequest: FourSquareRequest {
    var photo: VenueDetails.BestPhoto

    func prepare(context: FourSquareContext) throws -> URLRequest {
        try URL(string: photo.prefix)
            .restoreNil { throw "incorrect photo prefix \(photo.prefix)".mayDay }
            .appendingPathComponent(photo.suffix)
            .replace { URLRequest(url: $0) }
    }

    func parse(data: Data) throws -> UIImage {
        try UIImage(data: data)
            .restoreNil { throw "invalid image data at \(photo.prefix+photo.suffix)".mayDay }
    }

}

struct VenueListRequest: FourSquareRequest {

    // MARK: - Nestted Types

    typealias Output = [Venue]

    // MARK: - Instance Properties

    var latitude: Double
    var longitude: Double
    var radius: Double

    // MARK: - Instance Methods

    func prepare(context: FourSquareContext) throws -> URLRequest {
        try context.baseURL
            .appendingPathComponent("venues/search")
            .replace { URLComponents(url: $0, resolvingAgainstBaseURL: false) }
            .restoreNil { throw "incorrect base url".mayDay }
            .mutate { components in
                components.queryItems = [
                    context.clientId,
                    context.clientSecret,
                    .init(name: "v", value: "20201125"),
                    .init(name: "ll", value: "\(latitude),\(longitude)"),
                    .init(name: "radius", value: "\(radius)"),
                ]
            }
            .url
            .restoreNil { throw "incorrect url for \(self)".mayDay }
            .replace { URLRequest(url: $0) }
    }

    func parse(data: Data) throws -> [Venue] {
        return try JSONDecoder()
            .decode(VenueListResponse.self, from: data)
            .response.venues
    }
}
