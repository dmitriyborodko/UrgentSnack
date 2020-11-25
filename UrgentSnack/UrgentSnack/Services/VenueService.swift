import Foundation
import RxSwift

protocol VenueService {

}

class DefaultVenueService: VenueService {

    // MARK: - Instance Methods

    func fetchVenue(_ request: VenueListRequest) -> Observable<VenueListRequest.Output> {
        guard var components = URLComponents(url: Constants.searchVenuesURL, resolvingAgainstBaseURL: false) else {
            return .just([])
        }

        components.queryItems = [
            .clientID,
            .clientSecret,
            .location(latitude: request.latitude, longitude: request.longitude),
            .radius(request.radius),
            .limit,
            .accuracy
        ]

        guard let url = components.url else { return .just([]) }

//        let task = URLSession.shared.task

        return .just([])
    }
}

private enum Constants {

    // MARK: - Type Properties

//    https://api.foursquare.com/v2/venues/search?ll=40.7,-74&client_id=CLIENT_ID&client_secret=CLIENT_SECRET&v=YYYYMMDD

    static let searchVenuesURL = baseURL.appendingPathComponent("venues")
    static let detailsURL = baseURL

    static let limitQueryItemName = "limit"

    private static let baseURL = URL(string: "https://api.foursquare.com/v2/")!
}

private extension URLQueryItem {

    // MARK: - Type Properties

    static let clientID = URLQueryItem(name: "client_id", value: "QUPZTW4W2ZDT3JTVFAXWFVDCTIYYKQPMNNIRRPLMV2V5ZM2U")
    static let clientSecret = URLQueryItem(
        name: "client_secret",
        value: "OWPSD1WADXVX5L1BPMGYRE3P025SIKCFV1XJOTGV22GDB5V5"
    )
    static let limit = URLQueryItem(name: "limit", value: "\(10)")
    static let accuracy = URLQueryItem(name: "llAcc", value: "\(0)")

    // MARK: - Type Methods

    static func location(latitude: Double, longitude: Double) -> URLQueryItem {
        return URLQueryItem(
            name: "ll",
            value: "\(latitude),\(longitude)"
        )
    }

    static func radius(_ radius: Double) -> URLQueryItem {
        return URLQueryItem(
            name: "radius",
            value: "\(radius)"
        )
    }
}
