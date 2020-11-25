import Foundation

struct FourSquareContext {
    var clientId: URLQueryItem
    var baseURL: URL
    var clientSecret: URLQueryItem
    var version: URLQueryItem
}

protocol FourSquareRequest {
    associatedtype Output

    func prepare(context: FourSquareContext) throws -> URLRequest
    func parse(data: Data) throws -> Output
}
