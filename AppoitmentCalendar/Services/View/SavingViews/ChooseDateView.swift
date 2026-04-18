import SwiftUI

struct ChooseDateView: View {
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var appointment: AppointmentBooking

    @State private var selectedMonthOffset = 0
    @State private var selectedDate: Date? = nil

    private let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    var body: some View {
        ZStack {
            BookingScreenBackground()

            VStack(spacing: 14) {
                CustomNavBar(title: "Choose Date")

                BookingStepHeader(
                    step: 3,
                    total: 5,
                    title: "Choose Appointment Date",
                    subtitle: "Past days are disabled automatically."
                )
                .padding(.horizontal)
                .bookingEntrance(delay: 0.03)

                VStack(spacing: 14) {
                    monthSelector
                    weekDays
                    dateGrid
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(BookingTheme.surface)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(BookingTheme.surfaceBorder, lineWidth: 1)
                )
                .padding(.horizontal)
                .shadow(color: BookingTheme.accent.opacity(0.08), radius: 10, x: 0, y: 6)
                .bookingEntrance(delay: 0.10)

                Spacer(minLength: 0)
            }
        }
        .navigationBarBackButtonHidden()
        .safeAreaInset(edge: .bottom) {
            let isDisabled = selectedDate == nil

            VStack(spacing: 10) {
                Button {
                    guard let selectedDate else { return }
                    withAnimation(.spring(response: 0.32, dampingFraction: 0.8)) {
                        appointment.selectedDate = selectedDate
                    }
                    router.push(.chooseTime)
                } label: {
                    Text("Continue To Time")
                }
                .buttonStyle(BookingCTAButtonStyle(isDisabled: isDisabled))
                .disabled(isDisabled)
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 10)
            .background(.ultraThinMaterial)
        }
        .onAppear {
            let currentSelection = appointment.selectedDate
            if Calendar.current.startOfDay(for: currentSelection) >= Calendar.current.startOfDay(for: Date()) {
                selectedDate = currentSelection
            }
        }
    }

    private var monthSelector: some View {
        HStack {
            Button(action: { selectedMonthOffset -= 1 }) {
                Image(systemName: "chevron.left")
                    .font(.headline)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(BookingTheme.accent.opacity(0.14)))
                    .foregroundStyle(BookingTheme.accent)
            }

            Spacer()

            Text(monthTitle())
                .font(BookingTheme.body(18, weight: .bold))
                .foregroundStyle(BookingTheme.titleColor)

            Spacer()

            Button(action: { selectedMonthOffset += 1 }) {
                Image(systemName: "chevron.right")
                    .font(.headline)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(BookingTheme.accent.opacity(0.14)))
                    .foregroundStyle(BookingTheme.accent)
            }
        }
    }

    private var weekDays: some View {
        HStack {
            ForEach(daysOfWeek, id: \.self) { day in
                Text(day)
                    .font(BookingTheme.body(13, weight: .bold))
                    .foregroundStyle(BookingTheme.subtitleColor)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private var dateGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 7), spacing: 8) {
            ForEach(fetchDates()) { calendarDate in
                if calendarDate.day == 0 {
                    Color.clear
                        .frame(height: 42)
                } else {
                    let isSelected = selectedDate?.isSameDay(as: calendarDate.date) == true

                    Button {
                        if calendarDate.isEnabled {
                            withAnimation(.easeInOut(duration: 0.20)) {
                                selectedDate = calendarDate.date
                            }
                        }
                    } label: {
                        Text("\(calendarDate.day)")
                            .font(BookingTheme.body(14, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 42)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(dateBackgroundColor(isSelected: isSelected, isEnabled: calendarDate.isEnabled))
                            )
                            .foregroundStyle(dateTextColor(isSelected: isSelected, isEnabled: calendarDate.isEnabled))
                    }
                    .disabled(!calendarDate.isEnabled)
                }
            }
        }
    }

    private func dateBackgroundColor(isSelected: Bool, isEnabled: Bool) -> Color {
        if !isEnabled { return Color.gray.opacity(0.18) }
        if isSelected { return BookingTheme.accent }
        return Color.white.opacity(0.65)
    }

    private func dateTextColor(isSelected: Bool, isEnabled: Bool) -> Color {
        if !isEnabled { return .gray }
        if isSelected { return .white }
        return BookingTheme.titleColor
    }

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

extension Date {
    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }
}

#Preview {
    ChooseDateView()
        .environmentObject(AppointmentBooking())
        .environmentObject(NavigationRouter())
}
