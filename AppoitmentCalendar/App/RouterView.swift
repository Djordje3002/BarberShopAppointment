// RouterView.swift
import SwiftUI

struct RouterView: View {
    @EnvironmentObject var provider: ViewModelProvider

    var body: some View {
        NavigationStack(path: $provider.router.path) {
            Group {
                if provider.contentViewModel.currentUser?.isBarber == true {
                    BarberDashboardView()
                } else {
                    CustomTabBarApp()
                }
            }
                .navigationDestination(for: AppScreen.self) {
                    $0.destinationView(
                        appointment: provider.appointment,
                        registrationViewModel: provider.registrationViewModel
                    )
                }
        }
    }
}
