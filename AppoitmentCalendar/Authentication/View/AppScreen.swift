import SwiftUI

// Route type for NavigationStack
enum AppScreen: Hashable {
    // Authentication / registration flow
    case addEmail
    case createPassword
    case userName
    case phoneNumber
    case completeSignUp

    // Main app routes
    case home
    case chooseBarber
    case services
    case chooseDate
    case chooseTime
    case confirmAppointment
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
        case .addEmail:
            AddEmailView()
                .environmentObject(registrationViewModel)

        case .createPassword:
            CreatePasswordView()
                .environmentObject(registrationViewModel)

        case .userName:
            CreateUsernameView()
                .environmentObject(registrationViewModel)

        case .phoneNumber:
            AddPhoneNumber()
                .environmentObject(registrationViewModel)

        case .completeSignUp:
            CompleteSignUpView()
                .environmentObject(registrationViewModel)

        case .home:
            CustomTabBarApp()

        case .chooseBarber:
            ChooseBarberView()

        case .services:
            ServicesView()

        case .chooseDate:
            ChooseDateView()
                .environmentObject(appointment)

        case .chooseTime:
            ChooseTimeView()
                .environmentObject(appointment)

        case .confirmAppointment:
            ConfirmAppointmentView()
                .environmentObject(appointment)

        case .profile:
            ProfileView()

        case .waitingList:
            WaitListView()

        case .aboutApp:
            AboutAppView()

        case .notifications:
            NotificationsView()

        case .privacyPolicy:
            PrivacyPolicyView()
        }
    }
}
