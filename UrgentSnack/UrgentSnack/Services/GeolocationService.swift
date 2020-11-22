import Foundation
import CoreLocation

protocol GeolocationService {
    func authorize()
}

class DefaultGeolocationService: NSObject {

    // MARK: - Instance Properties

    private let locationManager = CLLocationManager()

    // MARK: - Initializers

    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
}

extension DefaultGeolocationService: CLLocationManagerDelegate {

    // MARK: - Instance Methods


}
