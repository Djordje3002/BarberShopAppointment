//
//  AppNavigation.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 30. 7. 2025..
//

import SwiftUI

// MARK: - Navigation Destinations Enum
enum AppScreen: Hashable {
    case home
    case sevices
    case choseDate
    case shoseTime
    case cofirmAppointment
    case successAppointment
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
    func destinationView() -> some View {
        switch self {
        case .home:
            HomeView()
        case .sevices:
            ServicesView()
        case .choseDate:
            ChooseDateView()
        case .shoseTime:
            ChooseTimeView()
        case .cofirmAppointment:
            ConfirmAppointmentView()
        case .successAppointment:
            SuccessAppointmentView()
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
//            LogoutView()
            EmptyView()
        }
    }
}


