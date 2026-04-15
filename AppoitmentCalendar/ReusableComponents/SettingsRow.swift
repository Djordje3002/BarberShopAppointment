import SwiftUI

struct SettingsRow: View {
    let text: String
    let icon: String
    let iconColor: Color
    let action: () -> Void
    
    init(text: String, icon: String, iconColor: Color = .black, action: @escaping () -> Void) {
        self.text = text
        self.icon = icon
        self.iconColor = iconColor
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(iconColor.opacity(0.1))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(iconColor)
                }
                
                Text(text)
                    .font(.body.weight(.medium))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.tertiary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor.secondarySystemBackground))
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SettingsRow(text: "Privacy", icon: "lock.shield.fill", iconColor: .blue, action: {})
        .padding()
}
