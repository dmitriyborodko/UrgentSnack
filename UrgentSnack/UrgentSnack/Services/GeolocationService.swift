import Foundation
import CoreLocation

protocol GeolocationService {
    func authorize()
}

class DefaultGeolocationService: NSObject {

    // MARK: - Instance Properties

    private var locationManager = CLLocationManager()

    // MARK: - Initializers

    override init() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
}

extension DefaultGeolocationService: CLLocationManagerDelegate {

    // MARK: - Instance Methods


}
