import UIKit
import MapKit

class MapViewController: UIViewController {

    // MARK: - Instance Properties

    private lazy var mapView = MKMapView()

    // MARK: - Instance Methods

    override func loadView() {
        view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension MapViewController: MKMapViewDelegate {

}
