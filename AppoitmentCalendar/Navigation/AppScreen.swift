// AppNavigation.swift

import SwiftUI

enum AppScreen: Hashable {
    case login
    case addEmail
    case createPassword
    case userName
    case phoneNumber
    case completeSignUp
    case home
    case services
    case chooseCut
    case chooseDate
    case chooseTime
    case confirmAppointment
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
            HomeView()

        case .services:
            ServicesView()
                .environmentObject(appointment)

        case .chooseCut:
            ChooseCutView()
                .environmentObject(appointment)

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
            AboutView()

        case .notifications:
            NotificationsView()

        case .privacyPolicy:
            PrivacyPolicy()
        }
    }
}
