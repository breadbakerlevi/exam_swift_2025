import SwiftUI

struct MapToolbar: View {
    @Binding var selectedCategory: Category
    @Binding var isLoading: Bool
    @Binding var featureCollection: FeatureCollection
    @Binding var errorMessage: String?
    @Binding var isShowingPlacesDetailView: Bool
    
    let savedLongitude: Double
    let savedLatitude: Double
    let dataService = DataService()
    
    var body: some View {
        HStack {
            Picker("Kategori", selection: $selectedCategory) {
                ForEach(Category.allCases, id: \.self) { category in
                    Text(category.displayName).tag(category)
                }
            }
            .pickerStyle(.segmented)
            
            // Hent data-knapp
            Button {
                Task {
                    isLoading = true
                    do {
                        featureCollection = try await dataService.getFeatures(
                            lon: savedLongitude,
                            lat: savedLatitude,
                            category: selectedCategory.rawValue
                        )
                    } catch {
                        errorMessage = "Kunne ikke hente steder fra API"
                    }
                    isLoading = false
                }
            } label: {
                Image(systemName: "arrow.clockwise")
            }
            
            // PlacesListView-knapp
            Button {
                isShowingPlacesDetailView = true
            } label: {
                Image(systemName: "list.bullet")
            }
        }
    }
}

#Preview {
}
