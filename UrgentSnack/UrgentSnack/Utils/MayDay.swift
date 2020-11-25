import Foundation

struct MayDay: Error, CustomStringConvertible {
    var description: String
}

extension String {
    var mayDay: MayDay { return MayDay.init(description: self) }
}
