import SwiftUI

// Route type for NavigationStack
enum AppScreen: Hashable {
    // Authentication / registration flow
    case createPassword
    case completeSignUp

    // Main app routes
    case home
    case services
    case chooseTime
    case profile
    case waitingList
    case aboutApp
    case notifications
    case privacyPolicy
}

// Centralized destination builder used in AuthRootView/ContentView
extension AppScreen {
    @ViewBuilder
    func destinationView(
        appointment: AppointmentBooking,
        registrationViewModel: RegistrationViewModel
    ) -> some View {
        switch self {
        case .createPassword:
            CreatePasswordView()
                .environmentObject(registrationViewModel)

        case .completeSignUp:
            CompleteSignUpView()
                .environmentObject(registrationViewModel)

        case .home:
            CustomTabBarApp()

        case .services:
            ServicesView()

        case .chooseTime:
            ChooseTimeView()
                .environmentObject(appointment)

        case .profile:
            ProfileView()

        case .waitingList:
            WaitingListView()

        case .aboutApp:
            AboutAppView()

        case .notifications:
            NotificationsView()

        case .privacyPolicy:
            PrivacyPolicyView()
        }
    }
}
