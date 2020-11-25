import Foundation
import RxSwift
import RxCocoa

class APIService {
    struct Env {
        var context: FourSquareContext
        var fetch: (URLRequest) -> Observable<Data>
        var worker: ConcurrentDispatchQueueScheduler
    }

    let env: Env

    init(env: Env) { self.env = env }

    func load<T: FourSquareRequest>(request: T) -> Observable<T.Output> {
        Observable
            .deferred { try Observable.of(request.prepare(context: self.env.context)) }
            .flatMap(env.fetch)
            .map(request.parse(data:))
    }
}
