import SwiftUI

struct ChooseTimeView: View {
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var appointment: AppointmentBooking

    @State private var isLoading = false
    @State private var selectedTime: String? = nil

    private let times = [
        "09:00 AM", "10:00 AM", "11:00 AM", "12:00 PM",
        "01:00 PM", "02:00 PM", "03:00 PM", "04:00 PM"
    ]

    var body: some View {
        ZStack {
            BookingScreenBackground()

            VStack(spacing: 14) {
                CustomNavBar(title: "Choose Time")

                BookingStepHeader(
                    step: 4,
                    total: 5,
                    title: "Select Time Slot",
                    subtitle: formattedDate(appointment.selectedDate)
                )
                .padding(.horizontal)
                .bookingEntrance(delay: 0.03)

                if isLoading {
                    ProgressView("Loading availability...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    legend
                        .padding(.horizontal)
                        .bookingEntrance(delay: 0.09)

                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 10) {
                            ForEach(Array(times.enumerated()), id: \.element) { index, time in
                                timeSlotButton(for: time)
                                    .bookingEntrance(delay: 0.12 + (Double(index) * 0.028))
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 130)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .safeAreaInset(edge: .bottom) {
            let isDisabled = selectedTime == nil || isLoading

            VStack(spacing: 8) {
                Button {
                    guard let selectedTime else { return }

                    guard !appointment.isSlotInPast(date: appointment.selectedDate, timeLabel: selectedTime) else {
                        appointment.errorMessage = "This slot is already in the past. Please choose a future time."
                        return
                    }

                    guard !appointment.isSlotBooked(
                        date: appointment.selectedDate,
                        timeLabel: selectedTime,
                        barberName: appointment.barberName
                    ) else {
                        appointment.errorMessage = "This slot is already booked. Please choose another time."
                        return
                    }

                    withAnimation(.spring(response: 0.3, dampingFraction: 0.82)) {
                        appointment.selectedTime = selectedTime
                    }
                    router.push(.confirmAppointment)
                } label: {
                    Text("Continue To Confirmation")
                }
                .buttonStyle(BookingCTAButtonStyle(isDisabled: isDisabled))
                .disabled(isDisabled)
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 10)
            .background(.ultraThinMaterial)
        }
        .task(id: refreshTaskId) {
            await refreshBookedSlots()
        }
        .onAppear {
            if !appointment.selectedTime.isEmpty {
                selectedTime = appointment.selectedTime
            }
        }
        .alert(isPresented: Binding<Bool>(
            get: { appointment.errorMessage != nil },
            set: { _ in appointment.errorMessage = nil }
        )) {
            Alert(
                title: Text("Booking"),
                message: Text(appointment.errorMessage ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private var legend: some View {
        HStack(spacing: 10) {
            legendItem(title: "Available", color: BookingTheme.accent.opacity(0.16), icon: "circle")
            legendItem(title: "Booked", color: Color.red.opacity(0.16), icon: "xmark")
            legendItem(title: "Past", color: Color.gray.opacity(0.18), icon: "clock")
        }
    }

    private func legendItem(title: String, color: Color, icon: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption.weight(.bold))
            Text(title)
                .font(BookingTheme.body(12, weight: .semibold))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(color)
        )
    }

    private func timeSlotButton(for time: String) -> some View {
        let isBooked = appointment.isSlotBooked(
            date: appointment.selectedDate,
            timeLabel: time,
            barberName: appointment.barberName
        )

        let isPast = appointment.isSlotInPast(
            date: appointment.selectedDate,
            timeLabel: time
        )

        let isSelected = selectedTime == time

        return Button {
            if !isBooked && !isPast {
                withAnimation(.easeOut(duration: 0.2)) {
                    selectedTime = time
                }
            }
        } label: {
            HStack {
                Text(time)
                    .font(BookingTheme.body(16, weight: .bold))
                Spacer(minLength: 8)
                if isBooked {
                    Image(systemName: "xmark.circle.fill")
                } else if isPast {
                    Image(systemName: "clock.fill")
                } else if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                }
            }
            .foregroundStyle(slotTextColor(isBooked: isBooked, isPast: isPast, isSelected: isSelected))
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(slotBackgroundColor(isBooked: isBooked, isPast: isPast, isSelected: isSelected))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(isSelected ? BookingTheme.accent : BookingTheme.surfaceBorder, lineWidth: isSelected ? 2 : 1)
            )
            .shadow(color: BookingTheme.accent.opacity(isSelected ? 0.14 : 0.03), radius: isSelected ? 9 : 4, x: 0, y: 3)
        }
        .buttonStyle(.plain)
        .disabled(isBooked || isPast || isLoading)
    }

    private func slotBackgroundColor(isBooked: Bool, isPast: Bool, isSelected: Bool) -> Color {
        if isBooked { return Color.red.opacity(0.2) }
        if isPast { return Color.gray.opacity(0.18) }
        if isSelected { return BookingTheme.accent.opacity(0.22) }
        return BookingTheme.surface
    }

    private func slotTextColor(isBooked: Bool, isPast: Bool, isSelected: Bool) -> Color {
        if isBooked { return .red }
        if isPast { return .gray }
        if isSelected { return BookingTheme.accent }
        return BookingTheme.titleColor
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }

    private var refreshTaskId: String {
        let dayStamp = Int(Calendar.current.startOfDay(for: appointment.selectedDate).timeIntervalSince1970)
        return "\(appointment.barberName)_\(dayStamp)"
    }

    private func refreshBookedSlots() async {
        isLoading = true
        do {
            try await appointment.refreshBookedSlots(
                date: appointment.selectedDate,
                barberName: appointment.barberName
            )

            if let selectedTime,
               appointment.isSlotBooked(
                date: appointment.selectedDate,
                timeLabel: selectedTime,
                barberName: appointment.barberName
               ) {
                self.selectedTime = nil
            } else if let selectedTime,
                      appointment.isSlotInPast(
                        date: appointment.selectedDate,
                        timeLabel: selectedTime
                      ) {
                self.selectedTime = nil
            }
        } catch {
            appointment.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
