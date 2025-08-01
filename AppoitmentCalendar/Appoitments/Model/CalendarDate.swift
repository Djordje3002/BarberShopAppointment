//
//  CalendarDate.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 29. 7. 2025..
//

import Foundation

struct CalendarDate: Identifiable {
    let id = UUID()
    let day: Int
    let date: Date
    let isEnabled: Bool
}
