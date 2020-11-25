import UIKit
import MapKit
import SnapKit

class MapViewController: UIViewController {

    // MARK: - Instance Properties

    private lazy var mapView: MKMapView = .init()
    private lazy var geolocationService: GeolocationService = DefaultGeolocationService()

    private let locationManager = CLLocationManager()

    // MARK: - Instance Methods

    private func authorizeGeolocation() {
        if case .notDetermined = locationManager.authorizationStatus {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    override func loadView() {
        view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
        mapView.showsUserLocation = true
//        authorizeGeolocation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        authorizeGeolocation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        authorizeGeolocation()
    }
}

extension MapViewController: CLLocationManagerDelegate {

}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }

        //create annotation view

        return MKAnnotationView()
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mapView.setCenter(userLocation.coordinate, animated: true)
    }
}
