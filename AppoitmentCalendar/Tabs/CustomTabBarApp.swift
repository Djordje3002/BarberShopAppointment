import SwiftUI

struct CustomTabBarApp: View {
    @State private var selectedTab: Tab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tag(Tab.home)
                .toolbar(.hidden, for: .tabBar)
            ChooseBarberView()
                .tag(Tab.services)
                .toolbar(.hidden, for: .tabBar)
            WaitListView()
                .tag(Tab.appointment)
                .toolbar(.hidden, for: .tabBar)
            NewsView()
                .tag(Tab.news)
                .toolbar(.hidden, for: .tabBar)
            SettingsView()
                .tag(Tab.profile)
                .toolbar(.hidden, for: .tabBar)
        }
        .accentColor(.white)
        .safeAreaInset(edge: .bottom) {
            CustomTabBar(selectedTab: $selectedTab)
                .padding(.horizontal, 14)
                .padding(.top, 8)
                .padding(.bottom, 8)
        }
    }
}

#Preview {
    NavigationStack {
        CustomTabBarApp()
    }
}
