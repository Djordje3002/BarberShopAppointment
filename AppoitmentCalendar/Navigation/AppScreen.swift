// AppNavigation.swift

import SwiftUI

enum AppScreen: Hashable {
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
    case logout
}

// MARK: - Navigation Destination Resolver
extension AppScreen {
    @ViewBuilder
    func destinationView(appointment: AppointmentBooking) -> some View {
        switch self {
        case .home:
            HomeView()
        case .sevices:
            ServicesView()
        case .choseCut:
            ChoseCutView()
        case .choseDate:
            ChooseDateView()
                .environmentObject(appointment)
        case .choseTime:
            ChooseTimeView(/*date: Date.now*/)
                .environmentObject(appointment)
        case .cofirmAppointment:
            ConfirmAppointmentView()
                .environmentObject(appointment)
        case .profile:
            ProfileView()
        case .waitingList:
            WaitListView()
        case .aboutApp:
            AboutApp()
        case .notifications:
            NotificationsView()
        case .privacyPolicy:
            PrivacyPolicy()
        case .logout:
            EmptyView()
        }
    }
}

