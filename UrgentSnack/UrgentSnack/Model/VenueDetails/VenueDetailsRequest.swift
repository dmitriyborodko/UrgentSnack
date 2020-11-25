import Foundation

struct VenueDetailsRequest: FourSquareRequest {
    typealias Output = VenueDetails

    var id: String

    func prepare(context: FourSquareContext) throws -> URLRequest {
        try context.baseURL
            .appendingPathComponent("venues/\(id)")
            .replace { URLComponents(url: $0, resolvingAgainstBaseURL: false) }
            .restoreNil { throw "incorrect base url".mayDay }
            .mutate { components in
                components.queryItems = [
                    context.clientId,
                    context.clientSecret,
                    .init(name: "v", value: "20201125"),
                ]
            }
            .url
            .restoreNil { throw "incorrect url for \(self)".mayDay }
            .replace { URLRequest(url: $0) }
    }

    func parse(data: Data) throws -> VenueDetails {
        return try JSONDecoder().decode(VenueDetailsResponse.self, from: data)
            .response.venue
    }
}
