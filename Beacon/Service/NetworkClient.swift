import Foundation

enum NetworkError: Error, LocalizedError {
    case badURL
    case requestFailed(statusCode: Int, data: Data?)
    case decodingError(Error)
    case urlSessionError(Error)
    case emptyData

    var errorDescription: String? {
        switch self {
        case .badURL:
            return "Ugyldig URL"
        case .requestFailed(let statusCode, _):
            return "Serverfeil. Statuskode: \(statusCode)"
        case .decodingError(let error):
            return "Dekodingsfeil: \(error.localizedDescription)"
        case .urlSessionError(let error):
            return "Nettverksfeil: \(error.localizedDescription)"
        case .emptyData:
            return "Tomt svar fra server"
        }
    }
}

struct NetworkClient {
    static let shared = NetworkClient()
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder

    init(urlSession: URLSession = .shared, jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    /// Utfør en GET-request og dekod responsen til typen T.
    func get<T: Decodable>(_ url: URL) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return try await requestDecodable(request)
    }

    /// Generisk request som dekoder JSON-responsen til T.
    func requestDecodable<T: Decodable>(_ request: URLRequest) async throws -> T {
        do {
            let (data, response) = try await urlSession.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.urlSessionError(URLError(.badServerResponse))
            }

            guard 200..<300 ~= httpResponse.statusCode else {
                throw NetworkError.requestFailed(statusCode: httpResponse.statusCode, data: data)
            }

            guard !data.isEmpty else {
                throw NetworkError.emptyData
            }

            do {
                let decoded = try jsonDecoder.decode(T.self, from: data)
                return decoded
            } catch {
                throw NetworkError.decodingError(error)
            }
        } catch is NetworkError {
            throw error
        } catch {
            throw NetworkError.urlSessionError(error)
        }
    }
}
