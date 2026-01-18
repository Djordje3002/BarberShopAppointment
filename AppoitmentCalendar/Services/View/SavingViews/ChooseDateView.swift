import SwiftUI

struct ChooseDateView: View {
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var appointment: AppointmentBooking

    @State private var selectedMonthOffset = 0
    @State private var selectedDate: Date? = nil

    let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    var body: some View {
        VStack {
            CustomNavBar(title: "Choose a date")
            ScrollView {
                VStack(spacing: 20) {
                    Text("Select a day for your appointment")
                        .font(.title2)
                        .bold()

                    monthSelector
                    weekDays
                    dateGrid

                    if selectedDate != nil {
                        CustomButton(title: "Next") {
                            if let selected = selectedDate {
                                appointment.selectedDate = selected
                                print("Selected date is: \(selected)")
                                router.push(.chooseTime)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden()
    }

    // MARK: - Month Selector View
    private var monthSelector: some View {
        HStack {
            Button(action: { selectedMonthOffset -= 1 }) {
                Image(systemName: "chevron.left")
            }
            Spacer()
            Text(monthTitle())
                .font(.headline)
            Spacer()
            Button(action: { selectedMonthOffset += 1 }) {
                Image(systemName: "chevron.right")
            }
        }
    }

    // MARK: - Week Days Header
    private var weekDays: some View {
        HStack {
            ForEach(daysOfWeek, id: \.self) { day in
                Text(day)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    // MARK: - Calendar Grid
    private var dateGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
            ForEach(fetchDates()) { calendarDate in
                if calendarDate.day == 0 {
                    Text("")
                        .frame(minHeight: 40)
                } else {
                    Button(action: {
                        if calendarDate.isEnabled {
                            selectedDate = calendarDate.date
                        }
                    }) {
                        Text("\(calendarDate.day)")
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .padding(8)
                            .background(
                                Circle().fill(
                                    selectedDate?.isSameDay(as: calendarDate.date) == true ? Color.blue : Color.clear
                                )
                            )
                            .foregroundColor(
                                calendarDate.isEnabled
                                    ? (selectedDate?.isSameDay(as: calendarDate.date) == true ? .white : .primary)
                                    : .gray
                            )
                    }
                    .disabled(!calendarDate.isEnabled)
                }
            }
        }
    }

    // MARK: - Helpers
    private func fetchDates() -> [CalendarDate] {
        let calendar = Calendar.current
        let monthStart = calendar.date(byAdding: .month, value: selectedMonthOffset, to: Date()) ?? Date()
        guard let range = calendar.range(of: .day, in: .month, for: monthStart) else { return [] }

        let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: monthStart)) ?? Date()
        let weekdayOffset = calendar.component(.weekday, from: firstOfMonth) - 2

        var dates: [CalendarDate] = []

        for _ in 0..<max(weekdayOffset, 0) {
            dates.append(CalendarDate(day: 0, date: Date(), isEnabled: false))
        }

        for day in range {
            let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) ?? Date()
            let isPast = calendar.startOfDay(for: date) < calendar.startOfDay(for: Date())
            dates.append(CalendarDate(day: day, date: date, isEnabled: !isPast))
        }

        return dates
    }

    private func monthTitle() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        let date = Calendar.current.date(byAdding: .month, value: selectedMonthOffset, to: Date()) ?? Date()
        return formatter.string(from: date)
    }
}

// ✅ REQUIRED extension for isSameDay comparison
extension Date {
    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }
}

// ✅ Dummy preview — only works if you inject environment objects
#Preview {
    ChooseDateView()
        .environmentObject(AppointmentBooking())
        .environmentObject(NavigationRouter())
}
