import Foundation
import CoreLocation
import RxSwift

protocol GeolocationService {
    func authorize() -> Observable<Void>
    func getUserLocation() -> Observable<CLLocation>
}

enum GeolocationError: Error {

}

// MARK: - Default Implementation

class DefaultGeolocationService: NSObject, GeolocationService {

    // MARK: - Instance Properties

    private let locationManager = CLLocationManager()

    // MARK: - Initializers

    override init() {
        super.init()

        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }

    // MARK: - Instance Methods

    func authorize() -> Observable<Void> {
        return Observable<Void>.just(())
    }

    func getUserLocation() -> Observable<CLLocation> {
        return Observable<CLLocation>.just(CLLocation())
    }
}

// MARK: - CLLocationManagerDelegate

extension DefaultGeolocationService: CLLocationManagerDelegate {

    // MARK: - Instance Methods


}
