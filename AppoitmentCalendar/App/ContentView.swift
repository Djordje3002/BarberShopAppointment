//
//  ContentView.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 30. 7. 2025..
//

import SwiftUI

struct ContentView: View {
    @StateObject private var router = NavigationRouter()

    var body: some View {
        NavigationStack(path: $router.path) {
            CustomTabBarApp()
                .navigationDestination(for: AppScreen.self) { $0.destinationView() }
        }
        .environmentObject(router) 
    }
}


#Preview {
    ContentView()
}
