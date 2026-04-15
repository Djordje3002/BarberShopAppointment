// ChooseTimeView.swift
import SwiftUI

struct ChooseTimeView: View {
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var appointment: AppointmentBooking

    @State private var isLoading = false
    @State private var selectedTime: String? = nil

    let times = [
        "09:00 AM", "10:00 AM", "11:00 AM", "12:00 PM",
        "01:00 PM", "02:00 PM", "03:00 PM", "04:00 PM"
    ]

    var body: some View {
        VStack {
            CustomNavBar(title: "Choose Time")

            Text("Select a time for")
                .font(.headline)

            Text(formattedDate(appointment.selectedDate))
                .font(.title2)
                .bold()

            if isLoading {
                ProgressView()
                    .padding()
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                    ForEach(times, id: \.self) { time in
                        let isBooked = appointment.isSlotBooked(
                            date: appointment.selectedDate,
                            timeLabel: time,
                            barberName: appointment.barberName
                        )
                        let isPast = appointment.isSlotInPast(
                            date: appointment.selectedDate,
                            timeLabel: time
                        )
                        Button(action: {
                            if !isBooked && !isPast {
                                selectedTime = time
                            }
                        }) {
                            Text(time)
                                .frame(maxWidth: .infinity)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(
                                            isBooked ? Color.red.opacity(0.3) :
                                            (isPast ? Color.gray.opacity(0.15) :
                                                (selectedTime == time ? Color.blue : Color.gray.opacity(0.2)))
                                        )
                                )
                                .foregroundColor(
                                    (isBooked || isPast) ? .gray :
                                        (selectedTime == time ? .white : .primary)
                                )
                                .overlay(
                                    Group {
                                        if isBooked {
                                            Image(systemName: "xmark")
                                                .foregroundColor(.red)
                                        } else if isPast {
                                            Image(systemName: "clock")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                )
                        }
                        .disabled(isBooked || isPast || isLoading)
                    }
                }
                .padding()
            }

            if selectedTime != nil {
                CustomButton(title: "Confirm") {
                    guard let selectedTime else { return }
                    guard !appointment.isSlotInPast(
                        date: appointment.selectedDate,
                        timeLabel: selectedTime
                    ) else {
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
                    appointment.selectedTime = selectedTime
                    router.push(.confirmAppointment)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }

            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden()
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 84)
        }
        .task(id: refreshTaskId) {
            await refreshBookedSlots()
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

//#Preview {
//    ChooseTimeView(date: Date.now)
//}
