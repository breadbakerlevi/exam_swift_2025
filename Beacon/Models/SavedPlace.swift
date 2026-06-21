import Foundation
import SwiftData

@Model
class SavedPlace {
    var id: UUID
    var name: String
    var address: String
    var lat: Double
    var lon: Double
    var openingHours: String?
    var website: String?
    var category: String
    var dateAdded: Date
    
    init(from feature: Feature, category: Category) {
        self.id = UUID()
        self.name = feature.properties.name
        self.address = feature.properties.addressLine2
        self.lat = feature.properties.lat
        self.lon = feature.properties.lon
        self.openingHours = feature.properties.openingHours
        self.website = feature.properties.website
        self.category = category.displayName
        self.dateAdded = Date()
    }
}
