import UIKit
import RxSwift
import RxCocoa

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?
    let bag = DisposeBag()
    
    // MARK: - Instance Methods

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        window = UIWindow(windowScene: windowScene)
        let linker = try! Linker()
        let map = MapViewController.make(env: linker.mapEnv)
        let navigationViewController = UINavigationController(rootViewController: map)

        map.idCast
            .map(linker.venueDetailsEnv(id:))
            .map(VenueViewController.make(env:))
            .bind(to: navigationViewController.rx.push(animated: true))
            .disposed(by: bag)

        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
    }
}

extension Reactive where Base: UINavigationController {
    func push(animated: Bool) -> Binder<UIViewController> {
        return .init(base) { controller, value in
            controller.pushViewController(value, animated: animated)
        }
    }
}
