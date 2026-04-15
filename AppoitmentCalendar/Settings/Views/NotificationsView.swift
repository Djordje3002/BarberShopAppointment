import SwiftUI

struct NotificationsView: View {
    @State private var bookingReminders = true
    @State private var promoNotifications = false

    var body: some View {
        Form {
            Toggle("Booking reminders", isOn: $bookingReminders)
            Toggle("Promotions and updates", isOn: $promoNotifications)
        }
        .navigationTitle("Notifications")
    }
}

#Preview {
    NavigationStack {
        NotificationsView()
    }
}
