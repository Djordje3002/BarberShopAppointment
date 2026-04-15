import SwiftUI

struct WaitListView: View {
    @EnvironmentObject var appointment: AppointmentBooking
    @EnvironmentObject var contentVM: ContentViewModel

    @State private var myAppointments: [UserAppointment] = []
    @State private var isLoading = false
    @State private var isDeleting = false
    @State private var appointmentPendingDelete: UserAppointment?
    @State private var showDeleteError = false
    @State private var deleteErrorMessage = ""

    var body: some View {
        VStack(spacing: 0) {
            CustomNavBar(title: "My Appointments")

            if isLoading || isDeleting {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if myAppointments.isEmpty {
                emptyState
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        appointmentSection(
                            title: "Upcoming Appointments",
                            subtitle: "Your next booked visits",
                            items: upcomingAppointments,
                            status: "Upcoming",
                            statusColor: .green
                        )

                        appointmentSection(
                            title: "Past / Finished",
                            subtitle: "Completed or expired bookings",
                            items: pastAppointments,
                            status: "Past",
                            statusColor: .gray
                        )
                    }
                    .padding()
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .task(id: contentVM.currentUser?.email ?? "") {
            await refreshAppointments()
        }
        .refreshable {
            await refreshAppointments()
        }
        .confirmationDialog(
            "Delete this appointment?",
            isPresented: Binding(
                get: { appointmentPendingDelete != nil },
                set: { isPresented in
                    if !isPresented {
                        appointmentPendingDelete = nil
                    }
                }
            ),
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                guard let appointmentToDelete = appointmentPendingDelete else { return }
                appointmentPendingDelete = nil
                Task {
                    await deleteAppointment(appointmentToDelete)
                }
            }

            Button("Cancel", role: .cancel) {
                appointmentPendingDelete = nil
            }
        } message: {
            Text("This will permanently remove the appointment.")
        }
        .alert("Delete Failed", isPresented: $showDeleteError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(deleteErrorMessage)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text("No appointments booked yet.")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var upcomingAppointments: [UserAppointment] {
        myAppointments
            .filter { $0.date >= Date() }
            .sorted { $0.date < $1.date }
    }

    private var pastAppointments: [UserAppointment] {
        myAppointments
            .filter { $0.date < Date() }
            .sorted { $0.date > $1.date }
    }

    private func appointmentSection(
        title: String,
        subtitle: String,
        items: [UserAppointment],
        status: String,
        statusColor: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title3.bold())
            Text(subtitle)
                .font(.footnote)
                .foregroundStyle(.secondary)

            if items.isEmpty {
                Text("No appointments")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                    )
            } else {
                VStack(spacing: 10) {
                    ForEach(items) { appt in
                        appointmentCard(appt, status: status, statusColor: statusColor)
                    }
                }
            }
        }
    }

    private func appointmentCard(_ appt: UserAppointment, status: String, statusColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top) {
                Text(appt.cutName)
                    .font(.headline)

                Spacer()

                Text(status)
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor.opacity(0.15))
                    .foregroundColor(statusColor)
                    .clipShape(Capsule())

                Text(String(format: "%.2f €", appt.price))
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }

            Text("Barber: \(appt.barberName)")
                .font(.subheadline)

            HStack {
                Image(systemName: "calendar")
                Text("\(formattedDate(appt.date)) at \(appt.time)")
            }
            .font(.footnote)
            .foregroundColor(.secondary)

            Text("Booked by: \(appt.username)")
                .font(.caption)
                .foregroundColor(.blue)
                .padding(.top, 2)

            Divider()
                .padding(.vertical, 4)

            HStack {
                Spacer()
                Button(role: .destructive) {
                    appointmentPendingDelete = appt
                } label: {
                    Label("Delete", systemImage: "trash")
                        .font(.subheadline.weight(.semibold))
                }
                .disabled(isDeleting)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.secondarySystemBackground))
        )
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func refreshAppointments() async {
        guard let email = contentVM.currentUser?.email else {
            myAppointments = []
            return
        }

        isLoading = true
        do {
            myAppointments = try await appointment.fetchUserAppointments(email: email)
        } catch {
            appointment.errorMessage = "Failed to fetch appointments: \(error.localizedDescription)"
        }
        isLoading = false
    }

    private func deleteAppointment(_ appt: UserAppointment) async {
        isDeleting = true
        do {
            try await appointment.deleteAppointment(appt)
            myAppointments.removeAll { $0.id == appt.id }
            await refreshAppointments()
        } catch {
            deleteErrorMessage = error.localizedDescription
            showDeleteError = true
        }
        isDeleting = false
    }
}

#Preview {
    WaitListView()
}
