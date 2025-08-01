//
//  AppoitmentCalendarApp.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 26. 7. 2025..
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}


@main
struct AppoitmentCalendarApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var appointment = AppointmentBooking()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appointment)
        }
    }
}
