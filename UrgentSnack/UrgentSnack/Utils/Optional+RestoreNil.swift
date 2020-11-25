import Foundation

extension Optional {
    func restoreNil(_ restore: () throws -> Wrapped) rethrows -> Wrapped { return try self ?? restore() }
}
