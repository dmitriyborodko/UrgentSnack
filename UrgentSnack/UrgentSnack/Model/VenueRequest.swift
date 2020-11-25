import Foundation

struct Foursquare {
    var clientId: URLQueryItem
    var baseURL: URL
    var clientSecret: URLQueryItem
}

struct MayDay: Error, CustomStringConvertible {
    var description: String
}
extension String {
    var mayDay: MayDay { return MayDay.init(description: self) }
}

protocol FoursquareRequest {
    associatedtype Output
    func prepare(context: Foursquare) throws -> URLRequest
    func parse(data: Data) throws -> Output
}

struct VenueRequest: FoursquareRequest {

    // MARK: - Nestted Types

    typealias Output = [Venue]

    // MARK: - Instance Properties

    var latitude: Double
    var longitude: Double
    var radius: Double

    func prepare(context: Foursquare) throws -> URLRequest {
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

//struct DetailRequest: FoursquareRequest {}

protocol Mutable {
    func mutate(apply: (inout Self) throws -> Void) rethrows -> Self
    func replace<T>(apply: (Self) throws -> T) rethrows -> T
}

extension Mutable {
    func mutate(apply: (inout Self) throws -> Void) rethrows -> Self {
        var result = self
        try apply(&result)
        return result
    }
    func replace<T>(apply: (Self) throws -> T) rethrows -> T { try apply(self) }
}

extension URLComponents: Mutable {}
extension URL: Mutable {}

extension Optional {
    func restoreNil(restore: () throws -> Wrapped) rethrows -> Wrapped { return try self ?? restore() }
}

import RxSwift
import RxCocoa

class Fours {
    struct Env {
        var context: Foursquare
        var session: URLSession
        var worker: ConcurrentDispatchQueueScheduler
    }
    let env: Env
    init(env: Env) { self.env = env }

    func load<T: FoursquareRequest>(request: T) -> Observable<T.Output> {
        Observable
            .deferred { try Observable.of(request.prepare(context: self.env.context)) }
            .flatMap(env.session.rx.data(request:))
            .map(request.parse(data:))
    }

}
