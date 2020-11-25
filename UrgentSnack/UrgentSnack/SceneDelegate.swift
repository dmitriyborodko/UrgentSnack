import UIKit
import RxSwift
import RxCocoa

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?
    let bag = DisposeBag()

    struct Env {
        var apiService: APIService
        var customer: SerialDispatchQueueScheduler

        init() throws {
            let urlSession = URLSession.shared
            self.apiService = try .init(
                env: .init(
                    context: .init(
                        clientId: .init(name: "client_id", value: "QUPZTW4W2ZDT3JTVFAXWFVDCTIYYKQPMNNIRRPLMV2V5ZM2U"),
                        baseURL: URL(string: "https://api.foursquare.com/v2//venues/search")
                            .restoreNil { throw "baseUrl invalid".mayDay },
                        clientSecret: .init(
                            name: "client_secret",
                            value: "OWPSD1WADXVX5L1BPMGYRE3P025SIKCFV1XJOTGV22GDB5V5"
                        )
                    ),
                    fetch: urlSession.rx.data(request:),
                    worker: .init(qos: .default)
                )
            )
            self.customer = MainScheduler.instance
        }

        var mapEnv: MapViewController.Env {
            return .init(
                mapService: .init(
                    env: .init(
                        loadVenues: apiService.load(request:),
                        serializer: .init(qos: .userInitiated),
                        customer: customer,
                        handleError: { error in
                            print(error)
                            print()
                        }
                    )
                )
            )
        }

        func venueDetailsEnv(id: String) -> VenueViewController.Env {
            return .init(
                detailsService: .init(
                    env: .init(
                        loadVenueDetails: apiService.load(request:),
                        customer: customer,
                        id: id,
                        handleError: { print($0) }
                    )
                )
            )
        }
    }
    // MARK: - Instance Methods

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        let env = try! Env()
        let map = MapViewController.make(env: env.mapEnv)
        let navigationViewController = UINavigationController(rootViewController: map)

        map.idCast
            .map(env.venueDetailsEnv(id:))
            .map(VenueViewController.make(env:))
            .bind(to: navigationViewController.rx.push(animated: true))
            .disposed(by: bag)

        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
    }
}

extension Reactive where Base: UINavigationController {
    func push(animated: Bool) -> Binder<UIViewController> {
        return .init(base) { this, value in this.pushViewController(value, animated: animated) }
    }
}
