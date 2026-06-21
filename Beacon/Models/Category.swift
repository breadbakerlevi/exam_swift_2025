import SwiftUI

enum Category: String, CaseIterable {
    case cafe = "catering.cafe"
    case restaurant = "catering.restaurant"
    case hotel = "accommodation.hotel"
    
    var displayName: String {
        switch self {
            case .cafe: return "Kafé"
            case .restaurant: return "Restaurant"
            case .hotel: return "Hotell"
        }
    }
    
    @ViewBuilder
    func animation() -> some View {
        switch self {
            case .cafe: CafeAnimation()
            case .restaurant: RestaurantAnimation()
            case .hotel: HotelAnimation()
        }
    }
}

private struct CafeAnimation: View {
    var body: some View {
        ZStack{
            Text("☕️")
                .font(.system(size: 60))

            VStack(spacing: 2) {
                SteamParticle()
                SteamParticle()
                SteamParticle()
                Spacer()
            }
            .offset(x: 0, y: -10)
            .frame(height: 100)
        }
        
    }
}

private struct SteamParticle: View {
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 1.0
    
    var body: some View {
        Text("💨")
            .font(.system(size: 10))
            .offset(y: offset)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 3).repeatForever(autoreverses: false)) {
                    offset = -50
                    opacity = 0.0
                }
            }
    }
}

private struct RestaurantAnimation: View {
    @State private var rotate = 0.0
    
    var body: some View {
        Text("🍽️")
            .font(.system(size: 60))
            .rotationEffect(.degrees(rotate))
            .onAppear{
                withAnimation(.easeInOut(duration: 1)) {
                    rotate = 360
                }
            }
    }
}

private struct HotelAnimation: View {
    @State private var scale: CGFloat = 0.5
    
    var body: some View {
        Text("🏨")
            .font(.system(size: 60))
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.5)) {
                    scale = 1.0
                }
            }
    }
}
