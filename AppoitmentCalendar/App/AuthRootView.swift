import SwiftUI

struct AuthRootView: View {
    @EnvironmentObject var provider: ViewModelProvider

    var body: some View {
        AuthFlow(
            router: provider.router,
            contentVM: provider.contentViewModel,
            provider: provider
        )
    }
}

private struct AuthFlow: View {
    @ObservedObject var router: NavigationRouter
    @ObservedObject var contentVM: ContentViewModel
    let provider: ViewModelProvider

    var body: some View {
        NavigationStack(path: $router.path) {
            Group {
                if contentVM.userSession == nil {
                    LoginView()
                        .environmentObject(provider.authViewModel)
                        .environmentObject(provider.registrationViewModel)
                } else if contentVM.currentUser != nil {
                    CustomTabBarApp()
                } else {
                    ProgressView("Loading...")
                }
            }
            .navigationDestination(for: AppScreen.self) {
                $0.destinationView(
                    appointment: provider.appointment,
                    registrationViewModel: provider.registrationViewModel
                )
            }
        }
        .environmentObject(router)
        .environmentObject(contentVM)
        .environmentObject(provider.appointment)
        .environmentObject(provider.authViewModel)
        .environmentObject(provider.registrationViewModel)
    }
}



#Preview {
    AuthRootView()
}
