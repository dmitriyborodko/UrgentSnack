import UIKit
import MapKit
import SnapKit
import RxSwift
import RxCocoa

final class MapViewController: UIViewController {

    // MARK: - Nested Types

    struct Env {
        var mapService: MapService
    }

    // MARK: - Type Methods

    static func make(env: Env) -> Self {
        let result = Self()
        result.env = env
        return result
    }

    // MARK: - Instance Properties

    var idCast: Observable<String> { idNode.asObservable() }

    fileprivate lazy var mapView: MKMapView = .init()

    private let locationManager = CLLocationManager()
    private let idNode = PublishSubject<String>()
    private let bag = DisposeBag()
    private var env: Env?

    // MARK: - Instance Methods

    override func loadView() {
        view = mapView

        navigationController?.setNavigationBarHidden(true, animated: false)

        locationManager.delegate = self

        mapView.register(
            VenueAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: VenueAnnotationView.reuseIdentifier
        )
        mapView.showsUserLocation = true
        mapView.delegate = self

        env?.mapService.clearCast().bind(to: rx.clear).disposed(by: bag)
        env?.mapService.insertCast().bind(to: rx.insertVenues).disposed(by: bag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        authorizeGeolocation()
    }

    private func zoom(to coordinate: CLLocationCoordinate2D) {
        let newCamera = MKMapCamera(
            lookingAtCenter: coordinate,
            fromEyeCoordinate: coordinate,
            eyeAltitude: 1000
        )
        mapView.setCamera(newCamera, animated: true)
    }

    private func authorizeGeolocation() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()

        case .authorizedAlways, .authorizedWhenInUse:
            zoom(to: mapView.userLocation.coordinate)

        default:
            break
        }
    }
}

private extension Reactive where Base: MapViewController {
    var clear: Binder<Void> {
        .init(base) { controller, _ in
            controller.mapView.removeAnnotations(controller.mapView.annotations)
        }
    }
    var insertVenues: Binder<Set<Venue>> {
        .init(base) { controller, venues in
            venues
                .map(Annotation.init(venue:))
                .forEach(controller.mapView.addAnnotation(_:))
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.first
            .map(\.coordinate)
            .map(zoom(to:))
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        env?.mapService.sendError(error)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }

        return mapView.dequeueReusableAnnotationView(withIdentifier: VenueAnnotationView.reuseIdentifier)
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        env?.mapService.regionSink(.init(region: mapView.region))
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.annotation
            .flatMap { $0 as? Annotation }
            .map(\.venue.id)
            .map(idNode.onNext)
    }
}

extension MapService.Region {
    init(region: MKCoordinateRegion) {
        self.point = .init(latitude: region.center.latitude, longitude: region.center.longitude)
        self.radius = CLLocation()
            .distance(from: CLLocation(latitude: region.span.latitudeDelta/2, longitude: region.span.longitudeDelta/2))
    }
}

class Annotation: NSObject, MKAnnotation {
    let venue: Venue

    init(venue: Venue) {
        self.venue = venue
        super.init()
    }

    var coordinate: CLLocationCoordinate2D {
        .init(latitude: venue.location.latitude, longitude: venue.location.longitude)
    }

    var title: String? { venue.name }
}
