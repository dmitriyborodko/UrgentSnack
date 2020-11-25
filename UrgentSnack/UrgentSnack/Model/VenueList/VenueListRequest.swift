import Foundation

struct VenueListRequest: FourSquareRequest {

    // MARK: - Nestted Types

    typealias Output = [Venue]

    // MARK: - Instance Properties

    var latitude: Double
    var longitude: Double
    var radius: Double

    // MARK: - Instance Methods

    func prepare(context: FourSquareContext) throws -> URLRequest {
        try URLComponents(url: context.baseURL, resolvingAgainstBaseURL: false)
            .restoreNil { throw "incorrect base url".mayDay }
            .mutate { components in
                components.queryItems = [
                    context.clientId,
                    context.clientSecret,
                    .init(name: "latitude", value: "\(latitude)"),
                    .init(name: "longitude", value: "\(longitude)"),
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
