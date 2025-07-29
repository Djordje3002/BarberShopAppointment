import SwiftUI

struct AppointmentView: View {
    let daysOfWeek: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    @State private var selectedMonthOffset = 0
    @State private var selectedDate: Date? = nil
    @State private var navigateToTimeSelection = false


    // Simulate disabled dates from backend
    private let disabledDates: [Date] = {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (1...10).compactMap {_ in 
            calendar.date(byAdding: .day, value: Int.random(in: 0...25), to: today)
        }
    }()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20.0) {

                    Divider()

                    VStack(spacing: 16.0) {
                        Text("Select a day")
                            .font(.title2)
                            .bold()

                        monthSelector
                        weekDays
                        dateGrid
                        if selectedDate != nil {
                            nextScreenButton
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Booking")
        }
    }

    func fetchSelectedMonth() -> Date {
        Calendar.current.date(byAdding: .month, value: selectedMonthOffset, to: Date())!
    }

    func getMonthTitle() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: fetchSelectedMonth())
    }

    func fetchDates() -> [CalendarDate] {
        let calendar = Calendar.current
        let currentMonth = fetchSelectedMonth()

        var dates: [CalendarDate] = []

        guard let range = calendar.range(of: .day, in: .month, for: currentMonth),
              let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth)) else {
            return dates
        }

        let weekdayOffset = calendar.component(.weekday, from: firstOfMonth) - 2
        let offset = weekdayOffset >= 0 ? weekdayOffset : 6

        for _ in 0..<offset {
            dates.append(CalendarDate(day: 0, date: Date(), isEnabled: false)) // Empty cell
        }

        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                let isPast = calendar.startOfDay(for: date) < calendar.startOfDay(for: Date())
                let isDisabled = disabledDates.contains { calendar.isDate($0, inSameDayAs: date) }
                let enabled = !isPast && !isDisabled
                dates.append(CalendarDate(day: day, date: date, isEnabled: enabled))
            }
        }

        return dates
    }
}

// MARK: - Subviews

extension AppointmentView {


    private var monthSelector: some View {
        HStack {
            Spacer()
            Button {
                selectedMonthOffset -= 1
            } label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .frame(width: 10, height: 20)
                    .foregroundStyle(.gray)
            }
            Spacer()
            Text(getMonthTitle())
                .font(.headline)
            Spacer()
            Button {
                selectedMonthOffset += 1
            } label: {
                Image(systemName: "chevron.right")
                    .resizable()
                    .frame(width: 10, height: 20)
                    .foregroundStyle(.gray)
            }
            Spacer()
        }
    }

    private var dateGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
            ForEach(fetchDates()) { calendarDate in
                if calendarDate.day == 0 {
                    Text("")
                        .frame(maxWidth: .infinity, minHeight: 40)
                } else {
                    let isSunday = Calendar.current.component(.weekday, from: calendarDate.date) == 1

                    Button {
                        if calendarDate.isEnabled && !isSunday {
                            selectedDate = calendarDate.date
                        }
                    } label: {
                        Text("\(calendarDate.day)")
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(selectedDate?.isSameDay(as: calendarDate.date) == true ? Color.blue : Color.clear)
                            )
                            .foregroundColor(
                                calendarDate.isEnabled && !isSunday
                                ? (selectedDate?.isSameDay(as: calendarDate.date) == true ? .white : .primary)
                                : .gray
                            )
                    }
                    .disabled(!calendarDate.isEnabled || isSunday)
                }
            }
        }
    }
    
    private var nextScreenButton: some View {
        VStack {
            Button(action: {
                navigateToTimeSelection = true
            }) {
                Text("Confirm Date")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            NavigationLink(
                destination: TimeSelectionView(date: selectedDate!),
                isActive: $navigateToTimeSelection,
                label: { EmptyView() }
            )
            .hidden()
        }
    }


    private var weekDays: some View {
        HStack {
            ForEach(daysOfWeek, id: \.self) { day in
                Text(day)
                    .font(.system(size: 12, weight: .medium))
                    .frame(maxWidth: .infinity)
            }
        }
    }
}


#Preview {
    AppointmentView()
}

