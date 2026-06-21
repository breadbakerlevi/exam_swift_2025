import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            MapView()
                .tabItem {
                    Label("Utforsk", systemImage: "map")
                }
            
            SavedPlacesList()
                .tabItem  {
                    Label("Mine steder", systemImage: "heart")
                }
        }
        .tint(Color.beaconOrange)
    }
}

#Preview {
    MainTabView()
}
