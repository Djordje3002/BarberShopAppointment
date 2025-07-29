//
//  Tab.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 30. 7. 2025..
//

import Foundation

enum Tab: String, CaseIterable {
    case home
    case services
    case appointment
    case news
    case profile
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .services: return "Services"
        case .appointment: return "Appoint"
        case .news: return "News"
        case .profile: return "Profile"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .services: return "scissors"
        case .appointment: return "calendar.badge.clock"
        case .news: return "newspaper"
        case .profile: return "person.crop.circle"
        }
    }
}
