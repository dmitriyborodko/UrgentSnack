import Foundation

struct VenueDetailsRequest: FourSquareRequest {

    // MARK: - Nestted Types
    
    typealias Output = VenueDetails

    // MARK: - Instance Properties

    var id: String

    // MARK: - Instance Methods

    func prepare(context: FourSquareContext) throws -> URLRequest {
        try context.baseURL
            .appendingPathComponent("venues")
            .replace { URLComponents(url: $0, resolvingAgainstBaseURL: false) }
            .restoreNil { throw "incorrect base url".mayDay }
            .mutate { components in
                components.queryItems = [
                    context.clientId,
                    context.clientSecret,
                    .init(name: "id", value: "\(id)"),
                    .init(name: "v", value: "20201125"),
                ]
            }
            .url
            .restoreNil { throw "incorrect url for \(self)".mayDay }
            .replace { URLRequest(url: $0) }
    }

    func parse(data: Data) throws -> VenueDetails {
        return try JSONDecoder().decode(VenueDetails.self, from: data)
    }
}
