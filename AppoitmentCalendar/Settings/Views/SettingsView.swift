

import SwiftUICore
import SwiftUI

struct SettingsView: View {
    @State private var path: [AppScreen] = []

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
                        .font(.title2.bold())
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)

                ScrollView {
                    VStack(spacing: 16) {
                        SettingsRow(text: "Profile", icon: "person.fill") {
                            path.append(.profile)
                        }

                        SettingsRow(text: "Waiting List", icon: "clock.arrow.circlepath") {
                            path.append(.waitingList)
                        }

                        SettingsRow(text: "About This App", icon: "info.circle") {
                            path.append(.aboutApp)
                        }

                        SettingsRow(text: "Notification", icon: "bell.fill") {
                            path.append(.notifications)
                        }

                        SettingsRow(text: "Location", icon: "location.fill") {
                            path.append(.location)
                        }

                        SettingsRow(text: "Privacy Policy", icon: "lock.shield.fill") {
                            path.append(.privacyPolicy)
                        }

                        SettingsRow(text: "Log Out", icon: "arrow.backward.square.fill") {
                            path.append(.logout)
                        }
                    }
                    .padding()
                }
            }
            .background(Color.black.ignoresSafeArea())
            .navigationDestination(for: AppScreen.self) { screen in
                switch screen {
                    case .profile: ProfileView()
                    case .waitingList: DetailPlaceholderView(title: "Waiting List")
                    case .aboutApp: DetailPlaceholderView(title: "About This App")
                    case .notifications: DetailPlaceholderView(title: "Notification")
                    case .location: DetailPlaceholderView(title: "Location")
                    case .privacyPolicy: DetailPlaceholderView(title: "Privacy Policy")
                    case .logout: DetailPlaceholderView(title: "Log Out")
                    default: EmptyView()
                }
            }
        }
    }
}


#Preview {
    SettingsView()
}
