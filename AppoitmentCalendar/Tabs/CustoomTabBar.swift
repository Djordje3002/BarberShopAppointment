import SwiftUI


struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    private var fillColor: Color = Color(.systemGray6).opacity(0.2)

    init(selectedTab: Binding<Tab>) {
        self._selectedTab = selectedTab
    }

    var body: some View {
        HStack {
            ForEach(Tab.allCases, id: \.self) { tab in
                Spacer()
                Button(action: {
                    withAnimation(.spring()) {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 20, weight: .bold))
                        Text(tab.title)
                            .font(.caption2)
                    }
                    .foregroundColor(selectedTab == tab ? .primary : .gray)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                }
                Spacer()
            }
        }
        .padding(.horizontal)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
        .padding(.horizontal)
        .padding(.bottom, 0)
        .ignoresSafeArea(.all, edges: .bottom)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 4)
    }
}

#Preview {
    CustomTabBarApp()
}
