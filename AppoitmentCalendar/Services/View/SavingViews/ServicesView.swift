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
        VStack(spacing: 14) {
            CustomNavBar(title: "Choose Haircut")

            Text("Step 2 of 5: Select your haircut")
                .font(.headline)
                .padding(.horizontal)

            if appointment.barberName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                VStack(spacing: 12) {
                    Text("Please select a barber first.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    CustomButton(title: "Go To Choose Barber") {
                        router.push(.chooseBarber)
                    }
                }
                Spacer()
            } else {
                HStack {
                    Text("Barber: \(appointment.barberName)")
                        .font(.subheadline.weight(.semibold))
                    Spacer()
                    Button("Change") {
                        router.push(.chooseBarber)
                    }
                    .font(.subheadline)
                }
                .padding(.horizontal)

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(options) { option in
                            HaircutCard(
                                option: option,
                                isSelected: appointment.selectedCut?.id == option.id,
                                action: {
                                    appointment.selectedCut = option
                                }
                            )
                        }
                    }
                    .padding(.top, 2)
                    .padding(.bottom, 100)
                }

                CustomButton(title: "Choose Date") {
                    router.push(.chooseDate)
                }
                .disabled(appointment.selectedCut == nil)
                .opacity(appointment.selectedCut == nil ? 0.5 : 1)
                .padding(.bottom, 8)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NavigationStack {
        ServicesView()
            .environmentObject(NavigationRouter())
            .environmentObject(AppointmentBooking())
    }
}
