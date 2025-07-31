//
//  NavigationRouter.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 31. 7. 2025..
//
    
import SwiftUI

final class NavigationRouter: ObservableObject {
    @Published var path: [AppScreen] = []

    func push(_ screen: AppScreen) {
        path.append(screen)
    }

    func pop() {
        _ = path.popLast()
    }

    func popToRoot() {
        path.removeAll()
    }
}
