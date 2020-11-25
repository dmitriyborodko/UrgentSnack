import MapKit

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
