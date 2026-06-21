import SwiftUI

struct PlacesListView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let features: [Feature]
    
    var body: some View {
        NavigationStack {
            List(features, id: \.id) {feature in
                VStack(alignment: .leading, spacing: 8) {
                    Text(feature.properties.name)
                        .font(.headline.bold())
                        .foregroundColor(Color.beaconOrange)
                    Text("Adresse: \(feature.properties.addressLine2)")
                        .font(.subheadline)
                    //.foregroundStyle(.secondary)
                    Text("Åpningstider: \(feature.properties.openingHours ?? "Ikke tilgjengelig")")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(4)
            }
            .navigationTitle("I nærheten av deg")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Lukk") {
                        dismiss()
                    }
                }
            }
            .presentationDragIndicator(.visible)

        }
    }
}

#Preview {
    PlacesListView(features: [])
}
