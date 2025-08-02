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
                    Text("Email: \(user.email)")
                } else {
                    Text("Loading user info...")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)

            Spacer()

            Button("Book Now") {
                if let user = contentVM.currentUser {
                    appointment.bookAppointment(currentUser: user) {
                        print("✅ Appointment booked:")
                        print("Service: \(appointment.selectedCut?.name ?? "Not selected")")
                        print("Date: \(formattedDate(appointment.selectedDate))")
                        print("Time: \(appointment.selectedTime)")
                        print("Price: \(String(format: "%.2f", appointment.selectedCut?.price ?? 0)) €")
                        print("Booked by: \(user.username)")
                        print("Email: \(user.email)")
                        router.popToRoot()
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}
