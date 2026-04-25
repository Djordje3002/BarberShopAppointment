import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 44.7866, longitude: 20.4489),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    )

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Find Us Here")
                .font(.title2.bold())
                .padding(.horizontal)

            Map(position: $cameraPosition) {
                UserAnnotation()
            }
            .frame(height: 250)
            .cornerRadius(20)
            .padding()
        }
        .onReceive(locationManager.$currentLocation) { location in
            guard let loc = location else { return }
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: loc.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            )
        }
    }
}

#Preview {
    MapView()
}
