import Foundation

struct FeatureCollection: Decodable, Hashable {
    let type: String
    let features: [Feature]
}

struct Feature: Decodable, Hashable, Identifiable {
    var id = UUID()
    let properties: Properties
    
    enum CodingKeys: String, CodingKey {
        case properties
    }
}

struct Properties: Decodable, Hashable {
    let name: String
    let lon: Double
    let lat: Double
    let addressLine2: String
    let openingHours: String?
    let website: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case lon
        case lat
        case addressLine2 = "address_line2"
        case openingHours = "opening_hours"
        case website
    }
}
