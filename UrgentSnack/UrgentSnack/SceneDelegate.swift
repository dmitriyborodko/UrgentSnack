import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // MARK: - Instance Methods

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)

        let navigationViewController = UINavigationController()
        navigationViewController.setViewControllers([MapViewController()], animated: true)

        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
    }
}
