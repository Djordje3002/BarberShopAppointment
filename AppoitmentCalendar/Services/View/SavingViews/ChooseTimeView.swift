// ChooseTimeView.swift
import SwiftUI

struct ChooseTimeView: View {
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var appointment: AppointmentBooking

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

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                ForEach(times, id: \.self) { time in
                    Button(action: {
                        selectedTime = time
                    }) {
                        Text(time)
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedTime == time ? Color.blue : Color.gray.opacity(0.2))
                            )
                            .foregroundColor(selectedTime == time ? .white : .primary)
                    }
                }
            }
            .padding()

            if selectedTime != nil {
                CustomButton(title: "Confirm") {
                    appointment.selectedTime = selectedTime ?? ""
                    print("Selected time is \(selectedTime ?? "nil")")
                    router.push(.confirmAppointment)
                }
                .padding()
            }

            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden()
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}

//#Preview {
//    ChooseTimeView(date: Date.now)
//}
