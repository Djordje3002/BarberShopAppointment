import SwiftUI


struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    @Namespace private var selectionAnimation

    init(selectedTab: Binding<Tab>) {
        self._selectedTab = selectedTab
    }

    var body: some View {
        HStack(spacing: 8) {
            ForEach(Tab.allCases, id: \.self) { tab in
                Button(action: {
                    withAnimation(.spring(response: 0.34, dampingFraction: 0.82)) {
                        selectedTab = tab
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 15, weight: .bold))
                            .frame(width: 18, height: 18)

                        if selectedTab == tab {
                            Text(tab.title)
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .lineLimit(1)
                                .transition(
                                    .asymmetric(
                                        insertion: .opacity.combined(with: .move(edge: .trailing)),
                                        removal: .opacity
                                    )
                                )
                        }
                    }
                    .foregroundStyle(selectedTab == tab ? Color.white : Color(red: 0.36, green: 0.42, blue: 0.54))
                    .padding(.horizontal, selectedTab == tab ? 14 : 10)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background {
                        if selectedTab == tab {
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.08, green: 0.55, blue: 0.92),
                                            Color(red: 0.13, green: 0.42, blue: 0.92)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .matchedGeometryEffect(id: "ACTIVE_TAB", in: selectionAnimation)
                        } else {
                            Capsule()
                                .fill(Color.clear)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.94),
                            Color(red: 0.92, green: 0.95, blue: 1.00).opacity(0.90)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.95),
                            Color(red: 0.60, green: 0.70, blue: 0.88).opacity(0.45)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: .black.opacity(0.12), radius: 16, x: 0, y: 6)
    }
}

#Preview {
    CustomTabBarApp()
}
