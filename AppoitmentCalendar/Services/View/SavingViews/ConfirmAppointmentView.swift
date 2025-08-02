import SwiftUI

struct ConfirmAppointmentView: View {
    @EnvironmentObject var appointment: AppointmentBooking
    @EnvironmentObject var router: NavigationRouter

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            CustomNavBar(title: "Confirm Details")

            Group {
                Text("Service: \(appointment.selectedCut?.name ?? "Not selected")")
                Text("Date: \(formattedDate(appointment.selectedDate))")
                Text("Time: \(appointment.selectedTime)")
                Text("Price: \(String(format: "%.2f", appointment.selectedCut?.price ?? 0)) €")
                }
            .padding(.horizontal)

            Spacer()

            Button("Book Now") {
                appointment.bookAppointment {
                    print("Service: \(appointment.selectedCut?.name ?? "Not selected")")
                    print("Date: \(formattedDate(appointment.selectedDate))")
                    print(("Time: \(appointment.selectedTime)"))
                    print(("Price: \(String(format: "%.2f", appointment.selectedCut?.price ?? 0)) €"))
                    router.popToRoot()
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


