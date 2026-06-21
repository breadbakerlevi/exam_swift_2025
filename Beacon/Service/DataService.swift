import SwiftUI

struct DataService {
    func getFeatures(
        lon: Double,
        lat: Double,
        radius: Int = 1000,
        category: String,
        limit: Int = 10
    ) async throws -> FeatureCollection {
        
        let apiKey = "2926566dd63148a1b51e8cf676ce01ee"
        
        guard let url = URL(string: "https://api.geoapify.com/v2/places?categories=\(category)&filter=circle:\(lon),\(lat),\(radius)&limit=\(limit)&apiKey=\(apiKey)") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let fetchedFeatures = try JSONDecoder().decode(FeatureCollection.self, from: data)
            return fetchedFeatures
        } catch {
            print("Noe gikk gakt: \(error.localizedDescription)")
            throw error
        }
    }
}
