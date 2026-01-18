import SwiftUI

struct ConfirmAppointmentView: View {
    @EnvironmentObject var appointment: AppointmentBooking
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var contentVM: ContentViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            CustomNavBar(title: "Confirm Details")

            Group {
                Text("Service: \(appointment.selectedCut?.name ?? "Not selected")")
                Text("Date: \(formattedDate(appointment.selectedDate))")
                Text("Time: \(appointment.selectedTime)")
                Text("Price: \(String(format: "%.2f", appointment.selectedCut?.price ?? 0)) €")

                if let user = contentVM.currentUser {
                    Text("Booked by: \(user.username)")
                    Text("Email: \(user.email ?? "Email is not inserted")")
                } else {
                    Text("Loading user info...")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)

            Spacer()

            if appointment.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                Button("Book Now") {
                    guard let user = contentVM.currentUser else { return }
                    Task {
                        do {
                            try await appointment.bookAppointment(currentUser: user)
                            print("✅ Appointment booked:")
                            print("Service: \(appointment.selectedCut?.name ?? "Not selected")")
                            print("Date: \(formattedDate(appointment.selectedDate))")
                            print("Time: \(appointment.selectedTime)")
                            print("Price: \(String(format: "%.2f", appointment.selectedCut?.price ?? 0)) €")
                            print("Booked by: \(user.username)")
                            print("Email: \(user.email ?? "Email is not inserted")")
                            router.popToRoot()
                            appointment.reset()
                        } catch {
                            // errorMessage is already set inside AppointmentBooking, but you can log here as well
                            print("❌ Failed to book appointment: \(error.localizedDescription)")
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .disabled(appointment.selectedCut == nil)
                .padding()
            }
        }
        .alert(isPresented: Binding<Bool>(
            get: { appointment.errorMessage != nil },
            set: { _ in appointment.errorMessage = nil }
        )) {
            Alert(
                title: Text("Booking Failed"),
                message: Text(appointment.errorMessage ?? "An unknown error occurred."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}
