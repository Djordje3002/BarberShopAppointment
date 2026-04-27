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
        .onAppear {
            if appointment.barberName.isEmpty {
                appointment.barberName = "Michael"
            }
        }
        .navigationBarBackButtonHidden()
        .safeAreaInset(edge: .bottom) {
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

#Preview {
    NavigationStack {
        ServicesView()
            .environmentObject(NavigationRouter())
            .environmentObject(AppointmentBooking())
    }
}
