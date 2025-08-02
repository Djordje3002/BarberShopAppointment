import SwiftUI

struct ContentView: View {
    @StateObject private var router = NavigationRouter()
    @StateObject private var appointment = AppointmentBooking()
    @StateObject private var contentViewModel = ContentViewModel() // Observes AuthService
    @StateObject private var registrationViewModel = RegistrationViewModel()
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        NavigationStack(path: $router.path) {
            Group {
                if contentViewModel.userSession == nil {
                    LoginView()
                        .environmentObject(authViewModel)
                        .environmentObject(registrationViewModel)
                } else if contentViewModel.currentUser != nil {
                    CustomTabBarApp()
                        .navigationDestination(for: AppScreen.self) {
                            $0.destinationView(
                                appointment: appointment,
                                registrationViewModel: registrationViewModel
                            )
                        }
                } else {
                    ProgressView("Loading...")
                }
            }
        }
        .environmentObject(router)
        .environmentObject(appointment)
        .environmentObject(contentViewModel)
        .environmentObject(registrationViewModel)
        .environmentObject(authViewModel)
    }
}


#Preview {
    ContentView()
}

