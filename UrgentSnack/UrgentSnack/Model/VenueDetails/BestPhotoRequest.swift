import UIKit

struct BestPhotoRequest: FourSquareRequest {
    var photo: VenueDetails.BestPhoto

    func prepare(context: FourSquareContext) throws -> URLRequest {
        return try URL(string: photo.asString)
            .restoreNil { throw "incorrect photo prefix \(photo.asString)".mayDay }
            .replace { URLRequest(url: $0) }
    }

    func parse(data: Data) throws -> UIImage {
        try UIImage(data: data)
            .restoreNil { throw "invalid image data at \(photo.asString)".mayDay }
    }
}
