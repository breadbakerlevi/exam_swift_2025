import SwiftUI
import SwiftData

struct SavedPlacesList: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \SavedPlace.dateAdded, order: .reverse)
    
    private var savedPlaces: [SavedPlace]
    
    var body: some View {
        NavigationStack {
            if savedPlaces.isEmpty {
                VStack(alignment: .center) {
                    Text("Legg til dine steder!")
                }
                .padding()
            } else {
                List {
                    ForEach(savedPlaces) { savedPlace in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(savedPlace.name)
                                .font(.headline)
                                .foregroundColor(Color.beaconOrange)
                            Text(savedPlace.address)
                                .font(.subheadline)
                            
                            HStack {
                                Text(savedPlace.category)
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                                
                                Text("|")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                                
                                Text(savedPlace.dateAdded, style: .date)
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                                
                            }
                        }
                        .padding(4)
                    }
                    .onDelete(perform: deletePlaces)
                }
                .navigationTitle("Mine steder")
            }
        }
    }
    
    private func deletePlaces(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(savedPlaces[index])
        }
    }
}

#Preview {
    SavedPlacesList()
}


