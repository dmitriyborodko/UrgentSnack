import Foundation

extension Optional {
    func restoreNil(restore: () throws -> Wrapped) rethrows -> Wrapped { return try self ?? restore() }
}
