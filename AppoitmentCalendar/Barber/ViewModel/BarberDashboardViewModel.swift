import Foundation
import FirebaseFirestore

struct BarberDashboardAppointment: Identifiable {
    let id: String
    let barberId: String
    let clientName: String
    let slotStartAt: Date
    let dateKey: String
    let time24: String

    init?(id: String, data: [String: Any]) {
        guard let barberId = data["barberId"] as? String else { return nil }

        let timestamp = (data["slotStartAt"] as? Timestamp) ?? (data["date"] as? Timestamp)
        guard let slotStartAt = timestamp?.dateValue() else { return nil }

        let storedDateKey = data["dateKey"] as? String
        let storedTime24 = data["time24"] as? String

        self.id = id
        self.barberId = barberId
        self.slotStartAt = slotStartAt
        self.dateKey = storedDateKey ?? Self.dateKeyFormatter.string(from: slotStartAt)
        self.time24 = storedTime24 ?? Self.time24Formatter.string(from: slotStartAt)

        let userName = data["userName"] as? String
        let username = data["username"] as? String
        let fallbackName = data["email"] as? String
        self.clientName = userName ?? username ?? fallbackName ?? "Client"
    }

    var rowTitle: String {
        "\(time24) — \(clientName)"
    }

    private static let dateKeyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private static let time24Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}

@MainActor
final class BarberDashboardViewModel: ObservableObject {
    @Published private(set) var todaysAppointments: [BarberDashboardAppointment] = []
    @Published private(set) var nextAppointment: BarberDashboardAppointment?
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    private var activeBarberId: String?
    private var activeDateKey: String?

    func startTodayListener(barberId: String, selectedDate: Date = Date()) {
        let normalizedBarberId = BarberDirectory.normalizedBarberId(from: barberId)
        let dateKey = Self.dateKeyFormatter.string(from: selectedDate)

        if activeBarberId == normalizedBarberId,
           activeDateKey == dateKey,
           listener != nil {
            return
        }

        stopListening(resetData: false)
        isLoading = true
        errorMessage = nil
        activeBarberId = normalizedBarberId
        activeDateKey = dateKey

        let indexedQuery = db.collection("appointments")
            .whereField("barberId", isEqualTo: normalizedBarberId)
            .whereField("dateKey", isEqualTo: dateKey)

        listener = indexedQuery.addSnapshotListener { [weak self] snapshot, error in
            guard let self else { return }

            if let error {
                let nsError = error as NSError
                if self.isMissingIndexError(nsError) {
                    self.startFallbackListener(barberId: normalizedBarberId, dateKey: dateKey)
                    return
                }

                self.isLoading = false
                self.errorMessage = "Failed to fetch barber bookings: \(error.localizedDescription)"
                return
            }

            self.consumeSnapshot(snapshot, selectedDateKey: dateKey)
        }
    }

    func stopListening(resetData: Bool = true) {
        listener?.remove()
        listener = nil
        activeBarberId = nil
        activeDateKey = nil

        if resetData {
            todaysAppointments = []
            nextAppointment = nil
        }
    }

    private func startFallbackListener(barberId: String, dateKey: String) {
        listener?.remove()
        listener = db.collection("appointments")
            .whereField("barberId", isEqualTo: barberId)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self else { return }

                if let error {
                    self.isLoading = false
                    self.errorMessage = "Failed to fetch barber bookings: \(error.localizedDescription)"
                    return
                }

                self.consumeSnapshot(snapshot, selectedDateKey: dateKey)
            }
    }

    private func consumeSnapshot(_ snapshot: QuerySnapshot?, selectedDateKey: String) {
        let appointments = (snapshot?.documents ?? [])
            .compactMap { BarberDashboardAppointment(id: $0.documentID, data: $0.data()) }
            .filter { $0.dateKey == selectedDateKey }
            .sorted { $0.slotStartAt < $1.slotStartAt }

        todaysAppointments = appointments
        nextAppointment = appointments.first(where: { $0.slotStartAt > Date() })
        isLoading = false
    }

    private func isMissingIndexError(_ error: NSError) -> Bool {
        let message = error.localizedDescription.lowercased()
        return error.domain == FirestoreErrorDomain &&
            error.code == FirestoreErrorCode.failedPrecondition.rawValue &&
            message.contains("requires an index")
    }

    private static let dateKeyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
