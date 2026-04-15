import SwiftUI

struct AboutAppView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("About This App")
                    .font(.title2.bold())

                Text("BarberAppintment helps clients schedule barber appointments, pick services, and manage existing bookings in one place.")

                Text("Version 1.0")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }
}

#Preview {
    AboutAppView()
}
