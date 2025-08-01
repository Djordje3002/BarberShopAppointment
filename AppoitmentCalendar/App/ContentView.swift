import SwiftUI

struct ContentView: View {
    @StateObject private var router = NavigationRouter()
    @StateObject private var appointment = AppointmentBooking()

    var body: some View {
        NavigationStack(path: $router.path) {
            CustomTabBarApp()
                .navigationDestination(for: AppScreen.self) { $0.destinationView(appointment: appointment) }
        }
        .environmentObject(router)
        .environmentObject(appointment)
    }
}

#Preview {
    ContentView()
}

