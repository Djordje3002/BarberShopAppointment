import SwiftUI

struct ConfirmAppointmentView: View {
    @EnvironmentObject var appointment: AppointmentBooking
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var contentVM: ContentViewModel

    @State private var isSubmitting = false

    var body: some View {
        ZStack {
            BookingScreenBackground()

            VStack(spacing: 14) {
                CustomNavBar(title: "Confirm")

                BookingStepHeader(
                    step: 5,
                    total: 5,
                    title: "Review and Confirm",
                    subtitle: "Check details once before placing your booking."
                )
                .padding(.horizontal)
                .bookingEntrance(delay: 0.03)

                ScrollView {
                    VStack(spacing: 12) {
                        summaryCard
                            .bookingEntrance(delay: 0.10)
                        bookedByCard
                            .bookingEntrance(delay: 0.14)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 120)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .safeAreaInset(edge: .bottom) {
            let isDisabled = !canBook || isSubmitting || appointment.isLoading

            VStack(spacing: 8) {
                if appointment.isLoading || isSubmitting {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                } else {
                    Button {
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
                    } label: {
                        Text("Book Appointment")
                    }
                    .buttonStyle(BookingCTAButtonStyle(isDisabled: isDisabled))
                    .disabled(isDisabled)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 10)
            .background(.ultraThinMaterial)
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

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            summaryRow(icon: "person.crop.circle", title: "Barber", value: appointment.barberName, isMissing: appointment.barberName.isEmpty)
            summaryRow(icon: "scissors", title: "Service", value: appointment.selectedCut?.name ?? "Not selected", isMissing: appointment.selectedCut == nil)
            summaryRow(icon: "calendar", title: "Date", value: formattedDate(appointment.selectedDate), isMissing: false)
            summaryRow(icon: "clock", title: "Time", value: appointment.selectedTime, isMissing: appointment.selectedTime.isEmpty)
            summaryRow(icon: "eurosign.circle", title: "Price", value: String(format: "%.2f EUR", appointment.selectedCut?.price ?? 0), isMissing: appointment.selectedCut == nil)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(BookingTheme.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(BookingTheme.surfaceBorder, lineWidth: 1)
        )
        .shadow(color: BookingTheme.accent.opacity(0.08), radius: 10, x: 0, y: 6)
    }

    private var bookedByCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Booked by")
                .font(BookingTheme.body(18, weight: .bold))
                .foregroundStyle(BookingTheme.titleColor)

            if let user = contentVM.currentUser {
                Text(user.username)
                    .font(BookingTheme.body(15, weight: .semibold))
                    .foregroundStyle(BookingTheme.titleColor)

                Text(user.email ?? "No email")
                    .font(BookingTheme.body(14, weight: .regular))
                    .foregroundStyle(BookingTheme.subtitleColor)
            } else {
                Text("Loading user info...")
                    .font(BookingTheme.body(14, weight: .regular))
                    .foregroundStyle(BookingTheme.subtitleColor)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(BookingTheme.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(BookingTheme.surfaceBorder, lineWidth: 1)
        )
        .shadow(color: BookingTheme.accent.opacity(0.08), radius: 10, x: 0, y: 6)
    }

    private func summaryRow(icon: String, title: String, value: String, isMissing: Bool) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.body.weight(.semibold))
                .foregroundStyle(isMissing ? Color.red : BookingTheme.accent)
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(BookingTheme.body(12, weight: .bold))
                    .foregroundStyle(BookingTheme.subtitleColor)

                Text(isMissing ? "Not selected" : value)
                    .font(BookingTheme.body(15, weight: .semibold))
                    .foregroundStyle(isMissing ? Color.red : BookingTheme.titleColor)
            }

            Spacer()
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }

    private var canBook: Bool {
        let hasCut = appointment.selectedCut != nil
        let hasBarber = !appointment.barberName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let hasTime = !appointment.selectedTime.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let hasUser = contentVM.currentUser != nil
        let isFuture = !appointment.isSlotInPast(date: appointment.selectedDate, timeLabel: appointment.selectedTime)

        return hasCut && hasBarber && hasTime && hasUser && isFuture
    }
}
