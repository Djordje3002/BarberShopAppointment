import SwiftUI
import MapKit
import CoreLocation

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 44.7866, longitude: 20.4489),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Find Us Here")
                .font(.title2.bold())
                .padding(.horizontal)

            Map(coordinateRegion: $region, showsUserLocation: true)
                .frame(height: 250)
                .cornerRadius(20)
                .padding()
        }
        .onReceive(locationManager.$currentLocation) { location in
            if let loc = location {
                region.center = loc.coordinate
            }
        }
    }
}



#Preview {
    MapView()
}
