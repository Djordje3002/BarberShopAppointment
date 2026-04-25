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
    @Published var selectedDate: Date = Date()

    @Published private(set) var selectedDateAppointments: [BarberDashboardAppointment] = []
    @Published private(set) var nextAppointment: BarberDashboardAppointment?
    @Published private(set) var isLoading = false
    @Published private(set) var isSavingAvailability = false
    @Published var errorMessage: String?

    @Published var isDayOff = false
    @Published var unavailableTimes24: Set<String> = []

    let allTimeSlots = AppointmentBooking.defaultTimeSlots

    private let db = Firestore.firestore()
    private let appointmentsCollection = "appointments"
    private let availabilityCollection = "barber_availability"

    private var appointmentsListener: ListenerRegistration?
    private var availabilityListener: ListenerRegistration?
    private var activeBarberId: String?
    private var allUpcomingAppointments: [BarberDashboardAppointment] = []
    private var availabilityByDateKey: [String: BarberDayAvailability] = [:]

    func start(barberId: String) {
        let normalizedBarberId = barberId.normalizedBarberId()

        if activeBarberId == normalizedBarberId,
           appointmentsListener != nil,
           availabilityListener != nil {
            return
        }

        stopListening(resetData: false)
        activeBarberId = normalizedBarberId
        errorMessage = nil
        isLoading = true

        startAppointmentsListener(barberId: normalizedBarberId)
        startAvailabilityListener(barberId: normalizedBarberId)

        if Calendar.current.startOfDay(for: selectedDate) < Calendar.current.startOfDay(for: Date()) {
            selectedDate = Date()
        }
        refreshDerivedState()
    }

    func stopListening(resetData: Bool = true) {
        appointmentsListener?.remove()
        availabilityListener?.remove()
        appointmentsListener = nil
        availabilityListener = nil
        activeBarberId = nil

        if resetData {
            selectedDateAppointments = []
            nextAppointment = nil
            allUpcomingAppointments = []
            availabilityByDateKey = [:]
            isDayOff = false
            unavailableTimes24 = []
        }
    }

    func selectDate(_ date: Date) {
        selectedDate = date
        refreshDerivedState()
    }

    func setDayOff(_ newValue: Bool) async {
        let previousState = (isDayOff, unavailableTimes24)
        isDayOff = newValue
        if newValue {
            unavailableTimes24 = []
        }
        await persistSelectedDateAvailability(previousState: previousState)
    }

    func toggleUnavailableTime(_ timeLabel: String) async {
        guard !isDayOff else { return }
        guard let time24 = Self.time24From(timeLabel: timeLabel) else { return }

        if selectedDateAppointments.contains(where: { $0.time24 == time24 }) {
            errorMessage = "This slot already has a booking and cannot be marked unavailable."
            return
        }

        let previousState = (isDayOff, unavailableTimes24)
        if unavailableTimes24.contains(time24) {
            unavailableTimes24.remove(time24)
        } else {
            unavailableTimes24.insert(time24)
        }

        await persistSelectedDateAvailability(previousState: previousState)
    }

    func isTimeBookedOnSelectedDate(_ timeLabel: String) -> Bool {
        guard let time24 = Self.time24From(timeLabel: timeLabel) else { return false }
        return selectedDateAppointments.contains(where: { $0.time24 == time24 })
    }

    func isTimeUnavailableOnSelectedDate(_ timeLabel: String) -> Bool {
        guard let time24 = Self.time24From(timeLabel: timeLabel) else { return false }
        return unavailableTimes24.contains(time24)
    }

    private func persistSelectedDateAvailability(previousState: (Bool, Set<String>)) async {
        guard let barberId = activeBarberId else { return }

        isSavingAvailability = true
        defer { isSavingAvailability = false }

        let date = selectedDate
        let startOfDay = Calendar.current.startOfDay(for: date)
        let dateKey = Self.dateKeyFormatter.string(from: startOfDay)
        let normalizedTimes = unavailableTimes24.sorted()
        let documentId = BarberDayAvailability.documentId(barberId: barberId, dateKey: dateKey)
        let docRef = db.collection(availabilityCollection).document(documentId)

        do {
            if !isDayOff && normalizedTimes.isEmpty {
                try await docRef.delete()
                availabilityByDateKey.removeValue(forKey: dateKey)
            } else {
                let data: [String: Any] = [
                    "barberId": barberId,
                    "dateKey": dateKey,
                    "dayStartAt": Timestamp(date: startOfDay),
                    "isDayOff": isDayOff,
                    "unavailableTimes24": normalizedTimes,
                    "updatedAt": FieldValue.serverTimestamp()
                ]
                try await docRef.setData(data, merge: true)

                if let updated = BarberDayAvailability(
                    id: documentId,
                    barberId: barberId,
                    dateKey: dateKey,
                    isDayOff: isDayOff,
                    unavailableTimes24: normalizedTimes,
                    dayStartAt: startOfDay
                ) {
                    availabilityByDateKey[dateKey] = updated
                }
            }

            refreshDerivedState()
        } catch {
            isDayOff = previousState.0
            unavailableTimes24 = previousState.1
            errorMessage = "Failed to update availability: \(error.localizedDescription)"
        }
    }

    private func startAppointmentsListener(barberId: String) {
        let todayStart = Calendar.current.startOfDay(for: Date())

        let indexedQuery = db.collection(appointmentsCollection)
            .whereField("barberId", isEqualTo: barberId)
            .whereField("slotStartAt", isGreaterThanOrEqualTo: Timestamp(date: todayStart))

        appointmentsListener = indexedQuery.addSnapshotListener { [weak self] snapshot, error in
            guard let self else { return }

            if let error {
                let nsError = error as NSError
                if self.isMissingIndexError(nsError) {
                    self.startAppointmentsFallbackListener(barberId: barberId)
                    return
                }

                self.isLoading = false
                self.errorMessage = "Failed to fetch barber bookings: \(error.localizedDescription)"
                return
            }

            self.consumeAppointmentsSnapshot(snapshot, from: todayStart)
        }
    }

    private func startAppointmentsFallbackListener(barberId: String) {
        appointmentsListener?.remove()
        appointmentsListener = db.collection(appointmentsCollection)
            .whereField("barberId", isEqualTo: barberId)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self else { return }

                if let error {
                    self.isLoading = false
                    self.errorMessage = "Failed to fetch barber bookings: \(error.localizedDescription)"
                    return
                }

                self.consumeAppointmentsSnapshot(snapshot, from: Calendar.current.startOfDay(for: Date()))
            }
    }

    private func consumeAppointmentsSnapshot(_ snapshot: QuerySnapshot?, from startDate: Date) {
        allUpcomingAppointments = (snapshot?.documents ?? [])
            .compactMap { BarberDashboardAppointment(id: $0.documentID, data: $0.data()) }
            .filter { $0.slotStartAt >= startDate }
            .sorted { $0.slotStartAt < $1.slotStartAt }

        refreshDerivedState()
        isLoading = false
    }

    private func startAvailabilityListener(barberId: String) {
        availabilityListener = db.collection(availabilityCollection)
            .whereField("barberId", isEqualTo: barberId)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self else { return }

                if let error {
                    self.errorMessage = "Failed to fetch barber availability: \(error.localizedDescription)"
                    return
                }

                let todayKey = Self.dateKeyFormatter.string(from: Date())
                let items = (snapshot?.documents ?? [])
                    .compactMap { BarberDayAvailability(documentId: $0.documentID, data: $0.data()) }
                    .filter { $0.dateKey >= todayKey }

                self.availabilityByDateKey = Dictionary(uniqueKeysWithValues: items.map { ($0.dateKey, $0) })
                self.refreshDerivedState()
            }
    }

    private func refreshDerivedState() {
        let selectedDateKey = Self.dateKeyFormatter.string(from: selectedDate)

        selectedDateAppointments = allUpcomingAppointments
            .filter { $0.dateKey == selectedDateKey }
            .sorted { $0.slotStartAt < $1.slotStartAt }

        nextAppointment = allUpcomingAppointments.first(where: { $0.slotStartAt > Date() })

        if let selectedAvailability = availabilityByDateKey[selectedDateKey] {
            isDayOff = selectedAvailability.isDayOff
            unavailableTimes24 = Set(selectedAvailability.unavailableTimes24)
        } else {
            isDayOff = false
            unavailableTimes24 = []
        }
    }

    private func isMissingIndexError(_ error: NSError) -> Bool {
        let message = error.localizedDescription.lowercased()
        return error.domain == FirestoreErrorDomain &&
            error.code == FirestoreErrorCode.failedPrecondition.rawValue &&
            message.contains("requires an index")
    }

    private static func time24From(timeLabel: String) -> String? {
        guard let date = timeLabelFormatter.date(from: timeLabel) else { return nil }
        return time24Formatter.string(from: date)
    }

    private static let dateKeyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private static let timeLabelFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = "hh:mm a"
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
