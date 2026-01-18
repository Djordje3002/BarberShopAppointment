

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var router: NavigationRouter

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

                    SettingsRow(
                        text: "Log Out",
                        icon: "arrow.backward.square.fill",
                        action: {
                            Task {
                                try? await AuthService.shared.signOut()
                            }
                        }
                    )
                }
                .padding()
            }
        }
    }
}



#Preview {
    SettingsView()
        .environmentObject(NavigationRouter())
}
