import SwiftUI

struct ContentView: View {
    @StateObject private var viewModelProvider = ViewModelProvider()

    var body: some View {
        NavigationStack(path: $viewModelProvider.router.path) {
            Group {
                if viewModelProvider.contentViewModel.userSession == nil {
                    LoginView()
                        .environmentObject(viewModelProvider.authViewModel)
                        .environmentObject(viewModelProvider.registrationViewModel)
                } else if viewModelProvider.contentViewModel.currentUser != nil {
                    CustomTabBarApp()
                } else {
                    ProgressView("Loading...")
                }
            }
            .navigationDestination(for: AppScreen.self) {
                $0.destinationView(
                    appointment: viewModelProvider.appointment,
                    registrationViewModel: viewModelProvider.registrationViewModel
                )
            }
        }
        .environmentObject(viewModelProvider.router)
        .environmentObject(viewModelProvider.appointment)
        .environmentObject(viewModelProvider.contentViewModel)
        .environmentObject(viewModelProvider.registrationViewModel)
        .environmentObject(viewModelProvider.authViewModel)
    }
}


#Preview {
    ContentView()
}

