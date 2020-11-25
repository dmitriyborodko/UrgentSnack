import Foundation

protocol Mutable {
    func mutate(apply: (inout Self) throws -> Void) rethrows -> Self
    func replace<T>(apply: (Self) throws -> T) rethrows -> T
}

extension Mutable {
    func mutate(apply: (inout Self) throws -> Void) rethrows -> Self {
        var result = self
        try apply(&result)
        return result
    }

    func replace<T>(apply: (Self) throws -> T) rethrows -> T {
        return try apply(self)
    }
}

extension URLComponents: Mutable {}
extension URL: Mutable {}
