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
    func destinationView() -> some View {
        switch self {
        case .home:
            HomeView()
        case .sevices:
            ServicesView()
        case .choseCut:
            ChoseCutView()
        case .choseDate:
            ChooseDateView()
//            Look at this later i am not sure
        case .choseTime:
            ChooseTimeView(date: Date.now)
        case .cofirmAppointment:
            ConfirmAppointmentView()
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


