//
//  Barber.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 1. 8. 2025..
//

import Foundation

enum Barber: String, Codable, Identifiable, CaseIterable {
    case michael = "Michael"
    case john = "John"
    case mirko = "Mirko"
    case vukasin = "Vukasin"

    var id: String { rawValue }

    var description: String {
        switch self {
        case .michael: return "CEO and Barber"
        case .john: return "Senior Barber"
        case .mirko: return "Young Barber"
        case .vukasin: return "Master Barber"
        }
    }

    var imageName: String {
        switch self {
        case .michael: return "barber-1"
        case .john: return "barber-2"
        case .mirko: return "barber-0"
        case .vukasin: return "barber-3"
        }
    }
}
