import SwiftUI
import MapKit
import SwiftData

struct PlacesDetailView: View {
    
    @Environment(\.modelContext) var modelContext

    let place: Feature
    let selectedCategory: Category
    
    @Query private var savedPlaces: [SavedPlace]
    
    private var isSaved: Bool {
        savedPlaces.contains {$0.name == place.properties.name && $0.address == place.properties.addressLine2 }
    }
    
    var body: some View {
        VStack (alignment: .center, spacing: 16) {
            VStack(spacing: 8){
                selectedCategory.animation()
                
                Text(selectedCategory.displayName)
                    .font(.title2)
                    .fontWeight(.medium)
            }
            .padding(.top, 30)
            
            Text(place.properties.name)
                .font(.title.bold())
                .foregroundColor(Color.beaconOrange)
        }

        // Stedsdetaljer
        VStack(alignment: .leading, spacing: 12) {
            Text("Adresse: \(place.properties.addressLine2)")
                .font(.subheadline)
            Text("Åpningstider: \(place.properties.openingHours ?? "Ikke tilgjengelig")")
                .font(.subheadline)
            Text("Nettside: \(place.properties.website ?? "Ikke tilgjengelig")")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            HStack{
                Button {
                    openMaps()
                } label: {
                    Image(systemName: "map")
                    Text("Åpne i Kart")
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                Button {
                    toggleSaveToList()
                } label: {
                    Image(systemName: isSaved ? "heart.fill" : "heart")
                    Text(isSaved ? "Fjern fra mine steder" : "Legg til mine steder")
                }
                .buttonStyle(.bordered)
            }
        }
        .presentationDragIndicator(.visible)
        .padding()
    }
    
    private func openMaps() {
        let coordinate = CLLocationCoordinate2D(
            latitude: place.properties.lat,
            longitude: place.properties.lon
        )
        let mapItem = MKMapItem(location: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), address: nil)
        mapItem.name = place.properties.name
        mapItem.openInMaps()
    }
    
    private func toggleSaveToList() {
        if isSaved {
            if let removeFromList = savedPlaces.first(where: {
                $0.name == place.properties.name && $0.address == place.properties.addressLine2
            }) {
                modelContext.delete(removeFromList)
            }
        } else {
            let addToList = SavedPlace(from: place, category: selectedCategory)
            modelContext.insert(addToList)
            
        }
    }
}
