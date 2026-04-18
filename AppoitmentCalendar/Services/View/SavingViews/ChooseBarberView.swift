import SwiftUI

struct ChooseBarberView: View {
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var appointment: AppointmentBooking

    private let barbers = BarberDirectory.featured

    var body: some View {
        ZStack {
            BookingScreenBackground()

            VStack(spacing: 14) {
                CustomNavBar(title: "Choose Barber")

                BookingStepHeader(
                    step: 1,
                    total: 5,
                    title: "Select Your Barber",
                    subtitle: "Choose who will handle your cut before service, date, and time."
                )
                .padding(.horizontal)
                .bookingEntrance(delay: 0.03)

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(Array(barbers.enumerated()), id: \.element.id) { index, barber in
                            barberCard(barber)
                                .bookingEntrance(delay: 0.06 + (Double(index) * 0.035))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 120)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }

    private func barberCard(_ barber: BarberProfile) -> some View {
        let isSelected = appointment.barberName == barber.name

        return Button {
            withAnimation(.spring(response: 0.32, dampingFraction: 0.8)) {
                appointment.barberName = barber.name
                appointment.selectedCut = nil
                appointment.selectedTime = ""
            }
            router.push(.services)
        } label: {
            HStack(spacing: 12) {
                Image(barber.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 74, height: 74)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                VStack(alignment: .leading, spacing: 5) {
                    Text(barber.name)
                        .font(BookingTheme.body(20, weight: .semibold))
                        .foregroundStyle(BookingTheme.titleColor)

                    Text(barber.bio)
                        .font(BookingTheme.body(14, weight: .regular))
                        .foregroundStyle(BookingTheme.subtitleColor)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "chevron.right")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(isSelected ? BookingTheme.accent : BookingTheme.subtitleColor)
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(BookingTheme.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(isSelected ? BookingTheme.accent : BookingTheme.surfaceBorder, lineWidth: isSelected ? 2 : 1)
            )
            .shadow(color: BookingTheme.accent.opacity(0.08), radius: 10, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        ChooseBarberView()
            .environmentObject(NavigationRouter())
            .environmentObject(AppointmentBooking())
    }
}
