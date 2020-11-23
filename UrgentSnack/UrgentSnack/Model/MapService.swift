import Foundation
import RxSwift
import CoreLocation

class MapService {

    // MARK: - Nested Types

    struct Cell: Hashable {
        let center: CLLocation
        let radius: Double
    }

    // MARK: - Instance Properties

    let loadVenue: (VenueRequest) -> Observable<VenueRequest.Output>

    private var venuse: Set<Venue> = .init()
    private var cells: Set<Cell> = .init()

    // MARK: - Initializers

    init(loadVenue: @escaping (VenueRequest) -> Observable<VenueRequest.Output>) {
        self.loadVenue = loadVenue
    }

    // MARK: - Instance Methods

    func didPan(location: CLLocation, radius: Double) {
        // TODO: implement
    }

    func didZoom(location: CLLocation, radius: Double) {
        // TODO: implement
    }

    private func fetchNewLocations(location: CLLocation, radius: Double) {
        // TODO: implement
    }

    private func clearLoadedCells() -> Observable<Void> {
        // TODO: implement
        return Observable<Void>.just(())
    }
}
