import SwiftUI

struct ServicesView: View {
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var appointment: AppointmentBooking

    private let options: [HaircutOption] = [
        HaircutOption(type: .classic, description: "Neat and timeless everyday style.", imageName: "barber-1"),
        HaircutOption(type: .fade, description: "Clean fade with modern finishing.", imageName: "barber-2"),
        HaircutOption(type: .beardTrim, description: "Precise shape-up and beard lineup.", imageName: "barber-3"),
        HaircutOption(type: .kidsCut, description: "Fast and comfortable cut for kids.", imageName: "barber-0")
    ]

    var body: some View {
        ZStack {
            BookingScreenBackground()

            VStack(spacing: 14) {
                CustomNavBar(title: "Choose Haircut")

                BookingStepHeader(
                    step: 2,
                    total: 5,
                    title: "Pick Your Service",
                    subtitle: "Select the haircut package for your appointment."
                )
                .padding(.horizontal)
                .bookingEntrance(delay: 0.03)

                if appointment.barberName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    missingBarberState
                        .bookingEntrance(delay: 0.10)
                    Spacer()
                } else {
                    selectedBarberCard
                        .bookingEntrance(delay: 0.08)

                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(Array(options.enumerated()), id: \.element.id) { index, option in
                                HaircutCard(
                                    option: option,
                                    isSelected: appointment.selectedCut?.id == option.id,
                                    action: {
                                        withAnimation(.spring(response: 0.32, dampingFraction: 0.8)) {
                                            appointment.selectedCut = option
                                        }
                                    }
                                )
                                .bookingEntrance(delay: 0.12 + (Double(index) * 0.035))
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .safeAreaInset(edge: .bottom) {
            if !appointment.barberName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                let isDisabled = appointment.selectedCut == nil

                VStack(spacing: 10) {
                    Button {
                        router.push(.chooseDate)
                    } label: {
                        Text("Choose Date")
                    }
                    .buttonStyle(BookingCTAButtonStyle(isDisabled: isDisabled))
                    .disabled(isDisabled)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 10)
                .background(.ultraThinMaterial)
            }
        }
    }

    private var selectedBarberCard: some View {
        HStack(spacing: 8) {
            Label("Barber: \(appointment.barberName)", systemImage: "person.crop.circle")
                .font(BookingTheme.body(15, weight: .semibold))
                .foregroundStyle(BookingTheme.titleColor)

            Spacer()

            Button("Change") {
                router.push(.chooseBarber)
            }
            .font(BookingTheme.body(14, weight: .bold))
            .foregroundStyle(BookingTheme.accent)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(BookingTheme.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(BookingTheme.surfaceBorder, lineWidth: 1)
        )
        .padding(.horizontal)
    }

    private var missingBarberState: some View {
        VStack(spacing: 12) {
            Text("Please select a barber first.")
                .font(BookingTheme.body(15, weight: .semibold))
                .foregroundStyle(BookingTheme.subtitleColor)

            CustomButton(title: "Go To Choose Barber") {
                router.push(.chooseBarber)
            }
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        ServicesView()
            .environmentObject(NavigationRouter())
            .environmentObject(AppointmentBooking())
    }
}
