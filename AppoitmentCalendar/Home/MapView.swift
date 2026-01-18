import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    
    // iOS 17+ camera position
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 44.7866, longitude: 20.4489),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    )
    
    // Keep region only for iOS 16 fallback
    @State private var legacyRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 44.7866, longitude: 20.4489),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Find Us Here")
                .font(.title2.bold())
                .padding(.horizontal)

            if #available(iOS 17.0, *) {
                Map(position: $cameraPosition) {
                    // Shows the user's blue dot annotation
                    UserAnnotation()
                }
                .mapControls {
//                    // Optional: add standard controls (iOS 17+)
//                    if #available(iOS 17.0, *) {
//                        UserLocationButton()
//                        Compass()
//                        MapScaleView()
//                    }
                }
                .frame(height: 250)
                .cornerRadius(20)
                .padding()
            } else {
                // iOS 16 fallback using deprecated API
                Map(coordinateRegion: $legacyRegion, showsUserLocation: true)
                    .frame(height: 250)
                    .cornerRadius(20)
                    .padding()
            }
        }
        .onReceive(locationManager.$currentLocation) { location in
            guard let loc = location else { return }
            if #available(iOS 17.0, *) {
                cameraPosition = .region(
                    MKCoordinateRegion(
                        center: loc.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                )
            } else {
                legacyRegion.center = loc.coordinate
            }
        }
    }
}

#Preview {
    MapView()
}
