import SwiftUI

struct HaircutCard: View {
    let option: HaircutOption
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(option.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 82, height: 82)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                VStack(alignment: .leading, spacing: 6) {
                    Text(option.name)
                        .font(BookingTheme.body(20, weight: .bold))
                        .foregroundStyle(BookingTheme.titleColor)

                    Text(option.description)
                        .font(BookingTheme.body(14, weight: .regular))
                        .foregroundStyle(BookingTheme.subtitleColor)
                        .lineLimit(2)

                    Text(String(format: "%.2f EUR", option.price))
                        .font(BookingTheme.body(14, weight: .bold))
                        .foregroundStyle(BookingTheme.accent)
                }

                Spacer(minLength: 12)

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? BookingTheme.accent : BookingTheme.subtitleColor)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(BookingTheme.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(isSelected ? BookingTheme.accent : BookingTheme.surfaceBorder, lineWidth: isSelected ? 2 : 1)
            )
            .shadow(color: BookingTheme.accent.opacity(isSelected ? 0.11 : 0.05), radius: 10, x: 0, y: 5)
            .contentShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HaircutCard(
        option: HaircutOption(
            type: .classic,
            description: "Timeless clean look.",
            imageName: "barber-1"
        ),
        isSelected: true,
        action: {}
    )
    .padding()
}
