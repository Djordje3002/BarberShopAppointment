import SwiftUI

struct BarberDashboardView: View {
    @EnvironmentObject var contentVM: ContentViewModel
    @StateObject private var viewModel = BarberDashboardViewModel()

    var body: some View {
        VStack(spacing: 0) {
            header

            if viewModel.isLoading {
                ProgressView("Loading today's bookings...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        nextAppointmentCard
                        todayAppointmentsCard
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
            viewModel.startTodayListener(barberId: barberId)
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
        let dateKey = Self.dateKeyFormatter.string(from: Date())
        return "\(barberId ?? "missing")_\(dateKey)"
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Barber Dashboard")
                    .font(.title2.bold())
                Text("Today: \(Self.headerDateFormatter.string(from: Date()))")
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

    private var nextAppointmentCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Next appointment")
                .font(.headline)

            if let next = viewModel.nextAppointment {
                Text("Next: \(next.rowTitle)")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary)
            } else {
                Text("No upcoming appointments for the rest of today.")
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

    private var todayAppointmentsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's appointments")
                .font(.headline)

            if viewModel.todaysAppointments.isEmpty {
                Text("No bookings yet.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.todaysAppointments) { appointment in
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

                    if appointment.id != viewModel.todaysAppointments.last?.id {
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

    private static let headerDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter
    }()

    private static let dateKeyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

#Preview {
    BarberDashboardView()
        .environmentObject(ContentViewModel())
}
