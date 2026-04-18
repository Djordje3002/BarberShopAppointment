import SwiftUI

enum BookingTheme {
    static let accent = Color(red: 0.09, green: 0.52, blue: 0.86)
    static let highlight = Color(red: 0.94, green: 0.72, blue: 0.23)
    static let surface = Color.white.opacity(0.9)
    static let surfaceBorder = Color.white.opacity(0.62)
    static let titleColor = Color(red: 0.12, green: 0.17, blue: 0.27)
    static let subtitleColor = Color(red: 0.36, green: 0.43, blue: 0.54)

    static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.90, green: 0.95, blue: 1.00),
            Color(red: 0.97, green: 0.98, blue: 1.00),
            Color(red: 1.00, green: 0.96, blue: 0.91)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static func heading(_ size: CGFloat = 28) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }

    static func sectionTitle(_ size: CGFloat = 22) -> Font {
        .system(size: size, weight: .semibold, design: .rounded)
    }

    static func body(_ size: CGFloat = 15, weight: Font.Weight = .medium) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
}

struct BookingScreenBackground: View {
    var body: some View {
        ZStack {
            BookingTheme.backgroundGradient
                .ignoresSafeArea()

            Circle()
                .fill(Color.white.opacity(0.35))
                .frame(width: 260, height: 260)
                .offset(x: 150, y: -330)

            Circle()
                .fill(BookingTheme.accent.opacity(0.08))
                .frame(width: 230, height: 230)
                .offset(x: -170, y: 310)
        }
    }
}

struct BookingProgressBar: View {
    let step: Int
    let total: Int

    var body: some View {
        VStack(spacing: 8) {
            GeometryReader { proxy in
                let width = proxy.size.width
                let progress = CGFloat(step) / CGFloat(max(total, 1))

                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.45))
                        .frame(height: 8)

                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [BookingTheme.accent, BookingTheme.highlight],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: width * progress, height: 8)
                }
            }
            .frame(height: 8)

            HStack(spacing: 8) {
                ForEach(1...total, id: \.self) { index in
                    Circle()
                        .fill(index <= step ? BookingTheme.accent : Color.white.opacity(0.5))
                        .frame(width: 8, height: 8)
                }
                Spacer()
            }
        }
    }
}

struct BookingStepHeader: View {
    let step: Int
    let total: Int
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("STEP \(step) OF \(total)")
                .font(BookingTheme.body(12, weight: .bold))
                .tracking(1)
                .foregroundStyle(BookingTheme.accent)

            Text(title)
                .font(BookingTheme.sectionTitle(28))
                .foregroundStyle(BookingTheme.titleColor)

            Text(subtitle)
                .font(BookingTheme.body(15, weight: .regular))
                .foregroundStyle(BookingTheme.subtitleColor)

            BookingProgressBar(step: step, total: total)
                .padding(.top, 4)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(BookingTheme.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(BookingTheme.surfaceBorder, lineWidth: 1)
        )
        .shadow(color: BookingTheme.accent.opacity(0.10), radius: 14, x: 0, y: 8)
    }
}

struct BookingCTAButtonStyle: ButtonStyle {
    var isDisabled: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(BookingTheme.body(17, weight: .bold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                LinearGradient(
                    colors: isDisabled
                        ? [Color.gray.opacity(0.55), Color.gray.opacity(0.45)]
                        : [BookingTheme.accent, BookingTheme.highlight],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
            .opacity(configuration.isPressed ? 0.94 : 1)
            .animation(.easeOut(duration: 0.16), value: configuration.isPressed)
    }
}

private struct BookingEntranceMotion: ViewModifier {
    let delay: Double
    @State private var isVisible = false

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 12)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(.easeOut(duration: 0.38)) {
                        isVisible = true
                    }
                }
            }
    }
}

extension View {
    func bookingEntrance(delay: Double = 0) -> some View {
        modifier(BookingEntranceMotion(delay: delay))
    }
}
