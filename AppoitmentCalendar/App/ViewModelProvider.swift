//
//  ViewModelProvider.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 3. 8. 2025..
//

import SwiftUI

@MainActor
final class ViewModelProvider: ObservableObject {
    @Published var authViewModel = AuthViewModel()
    @Published var contentViewModel = ContentViewModel()
    @Published var registrationViewModel = RegistrationViewModel()
    @Published var appointment = AppointmentBooking()
    @Published var router = NavigationRouter()
}
