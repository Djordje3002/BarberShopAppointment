//
//  AppointmentTab.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 30. 7. 2025..
//

import Foundation

enum AppointmentTab: String, CaseIterable {
    case upcoming, past

    var title: String {
        switch self {
        case .upcoming: return "Upcoming"
        case .past: return "Past"
        }
    }
}
