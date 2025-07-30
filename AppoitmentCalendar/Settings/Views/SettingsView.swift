

import SwiftUICore
import SwiftUI

struct SettingsView: View {
    @State private var path: [AppScreen] = []

    var body: some View {
        NavigationStack(path: $path) {
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

                        SettingsRow(text: "Privacy Policy", icon: "lock.shield.fill") {
                            path.append(.privacyPolicy)
                            }

                        SettingsRow(text: "Log Out", icon: "arrow.backward.square.fill") {
                            
                        }
                    }
                    .padding()
                }
            }
            .navigationDestination(for: AppScreen.self) { screen in
                switch screen {
                    case .profile: ProfileView()
                    case .waitingList: WaitListView()
                    case .aboutApp: AboutApp()
                    case .notifications: NotificationsView()
                    case .privacyPolicy: PrivacyPolicy()
                case .logout: EmptyView()
                    default: EmptyView()
                }
            }
        }
    }
}


#Preview {
    SettingsView()
}
