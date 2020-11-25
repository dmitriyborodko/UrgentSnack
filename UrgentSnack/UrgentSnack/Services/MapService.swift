import Foundation
import RxSwift
import CoreLocation

class MapService {

    // MARK: - Nested Types

    struct Env {
        var loadVenues: (VenueListRequest) -> Observable<VenueListRequest.Output>
        var serializer: SerialDispatchQueueScheduler
        var customer: SerialDispatchQueueScheduler
        var handleError: (Error) -> Void
    }

    struct Point: Equatable {
        var latitude: Double
        var longitude: Double
    }

    struct Region {
        var point: Point
        var deltas: Point
    }

    // MARK: - Instance Properties

    private let env: Env
    private let regionNode: PublishSubject<Region> = .init()
    private var venues: Set<Venue> = .init()

    // MARK: - Initializers

    init(env: Env) { self.env = env }

    // MARK: - Instance Methods
    var regionSink: (Region) -> Void { regionNode.onNext }

    func changeRegion(latitude: Double, longitude: Double, latitudeDelta: Double, longitudeDelta: Double) {
        regionNode.onNext(.init(
            point: .init(latitude: latitude, longitude: longitude),
            deltas: .init(latitude: latitudeDelta, longitude: longitudeDelta)
        ))
    }

    func clearCast() -> Observable<Void> {
        regionNode
            .observeOn(env.serializer)
            .distinctUntilChanged { $0.deltas == $1.deltas }
            .do(onNext: { _ in self.clear() })
            .map { _ in }
            .observeOn(env.customer)
    }

    func insertCast() -> Observable<Set<Venue>> {
        regionNode
            .map(VenueListRequest.init(region:))
            .flatMap { self.env.loadVenues($0)
                .do(onError: self.env.handleError)
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
        self.radius = (region.deltas.latitude.square() + region.deltas.longitude.square()).squareRoot()/2
    }
}
