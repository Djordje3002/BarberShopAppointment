import Foundation

struct CalendarDate: Identifiable {
    let id = UUID()
    let day: Int
    let date: Date
    let isEnabled: Bool
}
