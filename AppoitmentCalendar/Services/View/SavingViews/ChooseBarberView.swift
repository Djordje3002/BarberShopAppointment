import SwiftUI

struct ChooseBarberView: View {
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var appointment: AppointmentBooking

    private let barbers = BarberDirectory.featured

    var body: some View {
        VStack(spacing: 14) {
            CustomNavBar(title: "Choose Barber")

            Text("Step 1 of 5: Select your barber")
                .font(.headline)
                .padding(.horizontal)

            ScrollView {
                VStack(spacing: 10) {
                    ForEach(barbers) { barber in
                        Button {
                            appointment.barberName = barber.name
                            appointment.selectedCut = nil
                            appointment.selectedTime = ""
                            router.push(.services)
                        } label: {
                            HStack(spacing: 12) {
                                Image(barber.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 64, height: 64)
                                    .clipped()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))

                                VStack(alignment: .leading, spacing: 3) {
                                    Text(barber.name)
                                        .font(.headline)
                                    Text(barber.bio)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color(.secondarySystemBackground))
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NavigationStack {
        ChooseBarberView()
            .environmentObject(NavigationRouter())
            .environmentObject(AppointmentBooking())
    }
}
