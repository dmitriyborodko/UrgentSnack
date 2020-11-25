import Foundation
import RxSwift
import RxCocoa

class APIService {

    // MARK: - Nested Types

    struct Env {
        var context: FourSquareContext
        var fetch: (URLRequest) -> Observable<Data>
        var worker: ConcurrentDispatchQueueScheduler
    }

    // MARK: - Instance Properties

    let env: Env

    // MARK: - Initializers

    init(env: Env) { self.env = env }

    // MARK: - Instance Methods

    func load<T: FourSquareRequest>(request: T) -> Observable<T.Output> {
        Observable
            .deferred { try Observable.of(request.prepare(context: self.env.context)) }
            .flatMap(env.fetch)
            .map(request.parse(data:))
    }

}
