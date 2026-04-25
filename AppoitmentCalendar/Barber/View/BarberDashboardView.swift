import SwiftUI

struct BarberDashboardView: View {
    @EnvironmentObject var contentVM: ContentViewModel
    @StateObject private var viewModel = BarberDashboardViewModel()

    var body: some View {
        VStack(spacing: 0) {
            header

            if viewModel.isLoading {
                ProgressView("Loading bookings...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        scheduleDateCard
                        nextAppointmentCard
                        availabilityCard
                        selectedDateAppointmentsCard
                    }
                    .padding()
                    .padding(.bottom, 24)
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .task(id: listenerTaskId) {
            guard let barberId else {
                viewModel.stopListening()
                return
            }
            viewModel.start(barberId: barberId)
        }
        .onDisappear {
            viewModel.stopListening()
        }
        .alert("Booking Sync Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { _ in viewModel.errorMessage = nil }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Unknown error")
        }
    }

    private var barberId: String? {
        contentVM.currentUser?.resolvedBarberId
    }

    private var listenerTaskId: String {
        barberId ?? "missing"
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Barber Dashboard")
                    .font(.title2.bold())
                Text("Manage appointments and availability")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button("Log Out") {
                Task {
                    try? await AuthService.shared.signOut()
                }
            }
            .font(.subheadline.weight(.semibold))
        }
        .padding()
        .background(Color(.systemBackground))
    }

    private var scheduleDateCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Schedule Date")
                .font(.headline)

            DatePicker(
                "",
                selection: Binding(
                    get: { viewModel.selectedDate },
                    set: { viewModel.selectDate($0) }
                ),
                in: Date()...,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .labelsHidden()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.secondarySystemBackground))
        )
    }

    private var nextAppointmentCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Next appointment")
                .font(.headline)

            if let next = viewModel.nextAppointment {
                Text("Next: \(next.rowTitle)")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary)
            } else {
                Text("No upcoming appointments.")
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.secondarySystemBackground))
        )
    }

    private var availabilityCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Availability for \(Self.displayDateFormatter.string(from: viewModel.selectedDate))")
                .font(.headline)

            Toggle(
                "Day off (unavailable all day)",
                isOn: Binding(
                    get: { viewModel.isDayOff },
                    set: { newValue in
                        Task { await viewModel.setDayOff(newValue) }
                    }
                )
            )
            .disabled(viewModel.isSavingAvailability)

            if !viewModel.isDayOff {
                Text("Mark unavailable time slots")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 2), spacing: 8) {
                    ForEach(viewModel.allTimeSlots, id: \.self) { time in
                        availabilityTimeButton(time)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.secondarySystemBackground))
        )
    }

    private var selectedDateAppointmentsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Appointments on \(Self.displayDateFormatter.string(from: viewModel.selectedDate))")
                .font(.headline)

            if viewModel.isDayOff {
                Text("This day is marked as day off.")
                    .foregroundStyle(.secondary)
            }

            if viewModel.selectedDateAppointments.isEmpty {
                Text("No bookings for this date.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.selectedDateAppointments) { appointment in
                    HStack {
                        Text(appointment.time24)
                            .font(.body.weight(.semibold))
                        Text("—")
                            .foregroundStyle(.secondary)
                        Text(appointment.clientName)
                            .font(.body)
                        Spacer()
                    }
                    .padding(.vertical, 4)

                    if appointment.id != viewModel.selectedDateAppointments.last?.id {
                        Divider()
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.secondarySystemBackground))
        )
    }

    private func availabilityTimeButton(_ time: String) -> some View {
        let isBooked = viewModel.isTimeBookedOnSelectedDate(time)
        let isUnavailable = viewModel.isTimeUnavailableOnSelectedDate(time)

        return Button {
            Task {
                await viewModel.toggleUnavailableTime(time)
            }
        } label: {
            HStack {
                Text(time)
                    .font(.subheadline.weight(.semibold))
                Spacer(minLength: 6)
                if isBooked {
                    Image(systemName: "lock.fill")
                        .font(.caption.bold())
                } else if isUnavailable {
                    Image(systemName: "minus.circle.fill")
                        .font(.caption.bold())
                }
            }
            .foregroundStyle(timeButtonTextColor(isBooked: isBooked, isUnavailable: isUnavailable))
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(timeButtonBackgroundColor(isBooked: isBooked, isUnavailable: isUnavailable))
            )
        }
        .buttonStyle(.plain)
        .disabled(viewModel.isSavingAvailability || isBooked)
    }

    private func timeButtonBackgroundColor(isBooked: Bool, isUnavailable: Bool) -> Color {
        if isBooked { return Color.red.opacity(0.18) }
        if isUnavailable { return Color.gray.opacity(0.20) }
        return Color.white
    }

    private func timeButtonTextColor(isBooked: Bool, isUnavailable: Bool) -> Color {
        if isBooked { return .red }
        if isUnavailable { return .gray }
        return .primary
    }

    private static let displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

#Preview {
    BarberDashboardView()
        .environmentObject(ContentViewModel())
}
