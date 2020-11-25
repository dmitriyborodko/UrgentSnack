import Foundation
import RxSwift
import CoreLocation

class MapService {
    struct Env {
        var loadVenues: (VenueListRequest) -> Observable<VenueListRequest.Output>
        var serializer: SerialDispatchQueueScheduler
        var customer: SerialDispatchQueueScheduler
        var sendError: (Error) -> Void
    }

    struct Point: Equatable {
        var latitude: Double
        var longitude: Double
    }

    struct Region {
        var point: Point
        var radius: Double
    }

    var regionSink: (Region) -> Void { regionNode.onNext }
    var sendError: (Error) -> Void { env.sendError }

    private let env: Env
    private let regionNode: PublishSubject<Region> = .init()
    private var venues: Set<Venue> = .init()

    init(env: Env) { self.env = env }

    func changeRegion(latitude: Double, longitude: Double, radius: Double) {
        regionNode
            .onNext(.init(point: .init(latitude: latitude, longitude: longitude), radius: radius))
    }

    func clearCast() -> Observable<Void> {
        regionNode
            .observeOn(env.serializer)
            .distinctUntilChanged { one, two in
                abs(one.radius - two.radius) < 1000
            }
            .do(onNext: { _ in self.clear() })
            .map { _ in }
            .observeOn(env.customer)
    }

    func insertCast() -> Observable<Set<Venue>> {
        regionNode
            .map(VenueListRequest.init(region:))
            .flatMap { self.env.loadVenues($0)
                .do(onError: self.env.sendError)
                .catchError { _ in .empty() }

            }
            .observeOn(env.serializer)
            .map(insert(newVenues:))
            .observeOn(env.customer)
    }

    private func insert(newVenues: [Venue]) -> Set<Venue> {
        let result = Set(newVenues).subtracting(venues)
        venues = venues.union(result)
        return result
    }

    private func clear() {
        venues = .init()
    }
}

// MARK: - Helpers

private extension Double {
    func square() -> Self { self * self }
}

extension VenueListRequest {
    init(region: MapService.Region) {
        self.latitude = region.point.latitude
        self.longitude = region.point.longitude
        self.radius = region.radius
    }
}
