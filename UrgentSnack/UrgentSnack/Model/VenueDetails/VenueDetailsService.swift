import Foundation
import RxSwift
import CoreLocation

class VenueDetailsService {

    // MARK: - Nested Types

    struct Env {
        var loadVenueDetails: (VenueDetailsRequest) -> Observable<VenueDetailsRequest.Output>
        var loadBestPhoto: (BestPhotoRequest) -> Observable<BestPhotoRequest.Output>
        var customer: SerialDispatchQueueScheduler
        var id: String
        var sendError: (Error) -> Void
    }

    // MARK: - Instance Properties

    private let env: Env
    private let venueDetailsNode = PublishSubject<VenueDetails>()

    // MARK: - Initializers

    init(env: Env) { self.env = env }

    // MARK: - Instance Methods
    func activate() -> Disposable {
        Observable.of(env.id)
            .map(VenueDetailsRequest.init(id:))
            .flatMap(env.loadVenueDetails)
            .do(onError: env.sendError)
            .catchError { _ in .empty() }
            .subscribe(onNext: venueDetailsNode.onNext(_:))
    }

    func updateCast() -> Observable<String?> {
        venueDetailsNode
            .map { $0.name }
            .observeOn(env.customer)
    }

    func avatarCast() -> Observable<UIImage> {
        venueDetailsNode
            .map { BestPhotoRequest.init(photo: $0.bestPhoto) }
            .flatMap(env.loadBestPhoto)
            .catchError { _ in .empty() }
    }

    func likesCast() -> Observable<String?> {
        venueDetailsNode
            .map { $0.likes?.summary }
            .observeOn(env.customer)
    }

    func ratingCast() -> Observable<String?> {
        venueDetailsNode
            .map { $0.rating.flatMap(String.init(describing:)) }
            .observeOn(env.customer)
    }

    func descriptionCast() -> Observable<String?> {
        venueDetailsNode
            .map { $0.description }
            .observeOn(env.customer)
    }
}
