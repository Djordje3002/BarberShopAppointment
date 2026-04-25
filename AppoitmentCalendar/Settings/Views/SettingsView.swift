import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var router: NavigationRouter
    @State private var showLogoutAlert = false

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("Settings")
                    .font(.title2.bold())
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .foregroundColor(.black)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.bottom)

            ScrollView {
                VStack(spacing: 16) {
                    SettingsRow(text: "Profile", icon: "person.fill") {
                        router.push(.profile)
                    }

                    SettingsRow(text: "Waiting List", icon: "clock.arrow.circlepath") {
                        router.push(.waitingList)
                    }

                    SettingsRow(text: "About This App", icon: "info.circle") {
                        router.push(.aboutApp)
                    }

                    SettingsRow(text: "Notification", icon: "bell.fill") {
                        router.push(.notifications)
                    }

                    SettingsRow(text: "Privacy Policy", icon: "lock.shield.fill") {
                        router.push(.privacyPolicy)
                    }

                    #if DEBUG
                    SettingsRow(text: "Barber Accounts", icon: "person.3.fill") {
                        router.push(.seedBarberAccounts)
                    }
                    #endif

                    SettingsRow(
                        text: "Log Out",
                        icon: "arrow.backward.square.fill",
                        action: {
                            showLogoutAlert = true
                        }
                    )
                }
                .padding()
            }
        }
        .alert("Log Out", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Log Out", role: .destructive) {
                Task {
                    try? await AuthService.shared.signOut()
                }
            }
        } message: {
            Text("Are you sure you want to log out?")
        }
    }
}



#Preview {
    SettingsView()
        .environmentObject(NavigationRouter())
}
