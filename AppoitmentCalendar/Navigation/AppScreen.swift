// AppNavigation.swift

import SwiftUI

enum AppScreen: Hashable {
    case login
    case addEmail
    case createPassword
    case completeSignUp
    case home
    case sevices
    case choseCut
    case choseDate
    case choseTime
    case cofirmAppointment
    case profile
    case waitingList
    case aboutApp
    case notifications
    case privacyPolicy
}

// MARK: - Navigation Destination Resolver
extension AppScreen {
    @ViewBuilder
    func destinationView(
        appointment: AppointmentBooking,
        registrationViewModel: RegistrationViewModel
    ) -> some View {
        switch self {
        case .login:
            LoginView()
                .environmentObject(registrationViewModel)

        case .addEmail:
            AddEmailView()
                .environmentObject(registrationViewModel)

        case .createPassword:
            CreatePasswordView()
                .environmentObject(registrationViewModel)

        case .completeSignUp:
            CompleteSignUpView()
                .environmentObject(registrationViewModel)

        case .home:
            HomeView()

        case .sevices:
            ServicesView()
                .environmentObject(appointment)

        case .choseCut:
            ChoseCutView()
                .environmentObject(appointment)

        case .choseDate:
            ChooseDateView()
                .environmentObject(appointment)

        case .choseTime:
            ChooseTimeView()
                .environmentObject(appointment)

        case .cofirmAppointment:
            ConfirmAppointmentView()
                .environmentObject(appointment)

        case .profile:
            ProfileView()

        case .waitingList:
            WaitListView()

        case .aboutApp:
            AboutView()

        case .notifications:
            NotificationsView()

        case .privacyPolicy:
            PrivacyPolicy()
        }
    }
}
