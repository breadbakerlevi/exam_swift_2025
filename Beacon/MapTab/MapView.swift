import SwiftUI
import MapKit

struct MapView: View {
    
    // Appstorage
    @AppStorage("savedLatitude") private var savedLatitude: Double = 59.9111
    @AppStorage("savedLongitude") private var savedLongitude: Double = 10.7503
    
    // Kart
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(center:
                            CLLocationCoordinate2D(latitude: 59.9111, longitude: 10.7503),
                           span:
                            MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)
                          )
    )
    @State private var hasCenterMoved = false
    
    // DataService
    let dataService = DataService()
    @State private var featureCollection = FeatureCollection(type: "", features: [])
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    // Locationmanager
    @StateObject private var locationManager = LocationManager()
    
    // Kategori
    @State private var selectedCategory = Category.cafe
    
    // Detaljevisning
    @State private var isShowingPlacesDetailView = false
    @State private var selectedPlace: Feature?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Map(position: $position) {
                    UserAnnotation()
                    
                    ForEach(featureCollection.features, id: \.id) { feature in
                        Annotation(feature.properties.name, coordinate: CLLocationCoordinate2D(latitude: feature.properties.lat, longitude: feature.properties.lon)) {
                            Button {
                                selectedPlace = feature
                            } label: {
                                Image(.pin2)
                                    .resizable()
                                    .frame(width: 80, height: 80)
                            }
                        }
                    }
                    
                    // Kartets sentrum markør
                    if hasCenterMoved {
                        Annotation("", coordinate: CLLocationCoordinate2D(latitude: savedLatitude, longitude: savedLongitude)) {
                            Image(systemName: "mappin.and.ellipse.circle")
                                .font(.system(size: 30))
                                .foregroundColor(Color.beaconOrange)
                        }
                    }
                }
                .onAppear {
                    position = .region(MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: savedLatitude, longitude: savedLongitude),
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    )
                }
                .onMapCameraChange (frequency: .onEnd) { context in
                    let newCenter = context.region.center
                    
                    if newCenter.latitude != savedLatitude || newCenter.longitude != savedLongitude {
                        savedLatitude = newCenter.latitude
                        savedLongitude = newCenter.longitude
                        hasCenterMoved = true
                    }
                }
                
                // GPS-knapp
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            locationManager.askForPermission()
                            
                            if let userLocation = locationManager.userLocation {
                                position = .region(MKCoordinateRegion(
                                    center: userLocation.coordinate,
                                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                                )
                                
                                savedLatitude = userLocation.coordinate.latitude
                                savedLongitude = userLocation.coordinate.longitude
                                hasCenterMoved = true
                            }
                        } label: {
                            Image(systemName: "location")
                                .fontWeight(.medium)
                                .frame(width: 30, height: 38)
                        }
                        .buttonStyle(.glass)
                        .padding()
                    }
                }
                
                if isLoading {
                    ProgressView("Laster steder...")
                        .padding()
                }
                
                if let errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.highlightOrange)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                            .stroke(Color.beaconOrange)
                        )
                        .padding()
                }
            }
            .onChange(of: selectedCategory) {
                featureCollection = FeatureCollection(type: "", features: [])
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    MapToolbar(
                        selectedCategory: $selectedCategory,
                        isLoading: $isLoading,
                        featureCollection: $featureCollection,
                        errorMessage: $errorMessage,
                        isShowingPlacesDetailView: $isShowingPlacesDetailView,
                        savedLongitude: savedLongitude,
                        savedLatitude: savedLatitude
                    )
                }
            }            
            .sheet(isPresented: $isShowingPlacesDetailView) {
                PlacesListView(features: featureCollection.features)
            }
            .sheet(item: $selectedPlace) { place in
                PlacesDetailView(place: place, selectedCategory: selectedCategory)
                    .presentationDetents([.medium])
            }
        }
        
    }
}

#Preview {
    MapView()
}
