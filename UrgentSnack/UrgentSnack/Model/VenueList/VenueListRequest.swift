import UIKit

struct VenueListRequest: FourSquareRequest {
    typealias Output = [Venue]

    var latitude: Double
    var longitude: Double
    var radius: Double

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
                    .init(name: "categoryId", value: "4d4b7105d754a06374d81259")
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
