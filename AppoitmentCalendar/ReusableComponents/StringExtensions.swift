import Foundation

extension String {
    /// Produces a normalized barber ID: trimmed, lowercased, spaces replaced with dashes.
    /// Single source of truth used by `User`, `BarberProfile`, and `AppointmentBooking`.
    func normalizedBarberId() -> String {
        self
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .replacingOccurrences(of: " ", with: "-")
    }
}
