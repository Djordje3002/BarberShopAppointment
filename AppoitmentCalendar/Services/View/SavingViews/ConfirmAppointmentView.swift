import SwiftUI

struct ConfirmAppointmentView: View {
    @EnvironmentObject var appointment: AppointmentBooking
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var contentVM: ContentViewModel
    @State private var isSubmitting = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            CustomNavBar(title: "Confirm Details")

            Group {
                Text("Barber: \(appointment.barberName.isEmpty ? "⚠️ NOT SELECTED" : appointment.barberName)")
                    .foregroundColor(appointment.barberName.isEmpty ? .red : .primary)
                Text("Service: \(appointment.selectedCut?.name ?? "⚠️ NOT SELECTED")")
                    .foregroundColor(appointment.selectedCut == nil ? .red : .primary)
                Text("Date: \(formattedDate(appointment.selectedDate))")
                Text("Time: \(appointment.selectedTime.isEmpty ? "⚠️ NOT SELECTED" : appointment.selectedTime)")
                    .foregroundColor(appointment.selectedTime.isEmpty ? .red : .primary)
                Text("Price: \(String(format: "%.2f", appointment.selectedCut?.price ?? 0)) €")

                if let user = contentVM.currentUser {
                    Text("Booked by: \(user.username)")
                    Text("Email: \(user.email ?? "Email is not inserted")")
                } else {
                    Text("⚠️ Loading user info...")
                        .foregroundColor(.red)
                }
            }
            .padding(.horizontal)

            Spacer()

            if appointment.isLoading || isSubmitting {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                Button("Book Now") {
                    guard !isSubmitting else { return }
                    guard let user = contentVM.currentUser else {
                        appointment.errorMessage = "User profile not loaded. Please try logging out and back in."
                        return
                    }
                    isSubmitting = true
                    Task {
                        defer { isSubmitting = false }
                        do {
                            try await appointment.bookAppointment(currentUser: user)
                            appointment.reset()
                            router.popToRoot()
                        } catch {
                            appointment.errorMessage = error.localizedDescription
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(!canBook || isSubmitting || appointment.isLoading)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 84)
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

    private var canBook: Bool {
        let date = appointment.selectedDate
        let time = appointment.selectedTime
        let hasFutureSlot = isFutureSlot(date: date, timeLabel: time)
        let hasCut = appointment.selectedCut != nil
        let hasBarber = !appointment.barberName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let hasTime = !time.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let hasUser = contentVM.currentUser != nil
        return hasCut && hasBarber && hasTime && hasFutureSlot && hasUser
    }

    private func isFutureSlot(date: Date, timeLabel: String) -> Bool {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = "hh:mm a"

        guard let timeOnly = formatter.date(from: timeLabel) else {
            return false
        }

        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: timeOnly)
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute
        components.second = 0
        components.nanosecond = 0

        guard let slotDate = calendar.date(from: components) else {
            return false
        }

        return slotDate > Date()
    }
}
