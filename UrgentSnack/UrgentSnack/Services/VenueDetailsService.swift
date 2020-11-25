import Foundation
import RxSwift
import CoreLocation

class VenueDetailsService {

    // MARK: - Nested Types

    struct Env {
        var loadVenueDetails: (VenueDetailsRequest) -> Observable<VenueDetailsRequest.Output>
        var customer: SerialDispatchQueueScheduler
        var id: String
        var handleError: (Error) -> Void
    }

    // MARK: - Instance Properties

    private let env: Env

    // MARK: - Initializers

    init(env: Env) { self.env = env }

    // MARK: - Instance Methods

    func updateCast() -> Observable<VenueDetails> {
        Observable.of(env.id)
            .map(VenueDetailsRequest.init(id:))
            .flatMap(env.loadVenueDetails)
            .do(onError: env.handleError)
            .catchError { _ in .empty() }
            .observeOn(env.customer)
    }
}
