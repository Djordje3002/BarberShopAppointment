import Foundation
import SwiftUI
import FirebaseFirestore

@MainActor
final class AppointmentBooking: ObservableObject {

    @Published var selectedCut: HaircutOption?
    @Published var selectedDate: Date = Date()
    @Published var selectedTime: String = ""
    @Published var customerName: String = ""
    @Published var customerEmail: String = ""
    @Published var notes: String = ""
    @Published var barberName: String = ""

    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published private(set) var bookedSlotKeys: Set<String> = []

    private let db = Firestore.firestore()
    private let appointmentsCollection = "appointments"
    private let slotLocksCollection = "appointment_slots"

    func bookAppointment(currentUser: User) async throws {
        guard !isLoading else {
            throw AppointmentError.bookingInProgress
        }
        guard let selectedCut else {
            errorMessage = AppointmentError.noServiceSelected.localizedDescription
            throw AppointmentError.noServiceSelected
        }

        let cleanedBarberName = barberName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanedBarberName.isEmpty else {
            errorMessage = AppointmentError.missingBarber.localizedDescription
            throw AppointmentError.missingBarber
        }

        let cleanedTime = selectedTime.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanedTime.isEmpty else {
            errorMessage = AppointmentError.invalidSlot.localizedDescription
            throw AppointmentError.invalidSlot
        }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let barberId = normalizedBarberId(from: cleanedBarberName)
            let slotStartAt = try makeSlotDate(date: selectedDate, timeLabel: cleanedTime)
            guard slotStartAt > Date() else {
                errorMessage = AppointmentError.slotInPast.localizedDescription
                throw AppointmentError.slotInPast
            }
            let slotDate = Calendar.current.startOfDay(for: slotStartAt)
            let dateKey = Self.dateKeyFormatter.string(from: slotStartAt)
            let time24 = Self.time24Formatter.string(from: slotStartAt)
            let slotKey = makeSlotKey(barberId: barberId, dateKey: dateKey, time24: time24)
            let legacySlotKey = makeLegacySlotKey(barberId: barberId, slotStartAt: slotStartAt)

            let lockRef = db.collection(slotLocksCollection).document(slotKey)
            let appointmentRef = db.collection(appointmentsCollection).document(slotKey)
            let legacyLockRef = legacySlotKey == slotKey ? nil : db.collection(slotLocksCollection).document(legacySlotKey)
            let legacyAppointmentRef = legacySlotKey == slotKey ? nil : db.collection(appointmentsCollection).document(legacySlotKey)

            let lockData: [String: Any] = [
                "slotKey": slotKey,
                "barberId": barberId,
                "barberName": cleanedBarberName,
                "slotStartAt": Timestamp(date: slotStartAt),
                "slotDate": Timestamp(date: slotDate),
                "dateKey": dateKey,
                "time24": time24,
                "timeLabel": cleanedTime,
                "appointmentId": appointmentRef.documentID,
                "createdAt": FieldValue.serverTimestamp()
            ]

            let appointmentData: [String: Any] = [
                "slotKey": slotKey,
                "barberId": barberId,
                "barberName": cleanedBarberName,
                "cutName": selectedCut.name,
                "price": selectedCut.price,
                "slotStartAt": Timestamp(date: slotStartAt),
                "slotDate": Timestamp(date: slotDate),
                "dateKey": dateKey,
                "time24": time24,
                "timeLabel": cleanedTime,
                "date": Timestamp(date: slotStartAt),
                "time": time24,
                "userName": currentUser.username,
                "username": currentUser.username,
                "email": currentUser.email ?? "",
                "notes": notes,
                "createdAt": FieldValue.serverTimestamp(),
                "updatedAt": FieldValue.serverTimestamp(),
                "timestamp": Timestamp(date: Date())
            ]

            try await createBookingTransaction(
                lockRef: lockRef,
                appointmentRef: appointmentRef,
                legacyLockRef: legacyLockRef,
                legacyAppointmentRef: legacyAppointmentRef,
                lockData: lockData,
                appointmentData: appointmentData
            )

            bookedSlotKeys.insert(slotKey)
        } catch {
            if let bookingError = error as? AppointmentError {
                errorMessage = bookingError.localizedDescription
                throw bookingError
            }

            let nsError = error as NSError
            if nsError.domain == AppointmentError.errorDomain,
               nsError.code == AppointmentError.slotAlreadyBooked.code {
                errorMessage = AppointmentError.slotAlreadyBooked.localizedDescription
                throw AppointmentError.slotAlreadyBooked
            }

            let friendlyMessage = friendlyFirestoreMessage(for: nsError)
            errorMessage = AppointmentError.bookingFailed(friendlyMessage).localizedDescription
            throw AppointmentError.bookingFailed(friendlyMessage)
        }
    }

    func refreshBookedSlots(date: Date, barberName: String) async throws {
        let cleanedBarberName = barberName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanedBarberName.isEmpty else {
            bookedSlotKeys = []
            return
        }

        let barberId = normalizedBarberId(from: cleanedBarberName)
        let startOfDay = Calendar.current.startOfDay(for: date)
        guard let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay) else {
            bookedSlotKeys = []
            return
        }
        let dateKey = Self.dateKeyFormatter.string(from: startOfDay)

        do {
            let indexedSnapshot = try await db.collection(slotLocksCollection)
                .whereField("barberId", isEqualTo: barberId)
                .whereField("dateKey", isEqualTo: dateKey)
                .getDocuments()

            let keys = indexedSnapshot.documents.compactMap {
                canonicalSlotKey(from: $0.data(), fallbackDocumentId: $0.documentID)
            }
            bookedSlotKeys = Set(keys)
            return
        } catch {
            let nsError = error as NSError
            guard isMissingIndexError(nsError) else {
                throw error
            }
        }

        let fallbackSnapshot = try await db.collection(slotLocksCollection)
            .whereField("barberId", isEqualTo: barberId)
            .getDocuments()

        let fallbackKeys = fallbackSnapshot.documents.compactMap { document -> String? in
            let data = document.data()
            guard let slotTimestamp = data["slotStartAt"] as? Timestamp else { return nil }
            let slotDate = slotTimestamp.dateValue()
            guard slotDate >= startOfDay, slotDate < endOfDay else { return nil }
            return canonicalSlotKey(from: data, fallbackDocumentId: document.documentID)
        }

        bookedSlotKeys = Set(fallbackKeys)
    }

    func isSlotBooked(date: Date, timeLabel: String, barberName: String) -> Bool {
        guard let slotKey = slotKey(date: date, timeLabel: timeLabel, barberName: barberName) else {
            return true
        }
        return bookedSlotKeys.contains(slotKey)
    }

    func isSlotInPast(date: Date, timeLabel: String) -> Bool {
        guard let slotDate = try? makeSlotDate(date: date, timeLabel: timeLabel) else {
            return true
        }
        let now = Date()
        let calendar = Calendar.current

        if calendar.isDate(slotDate, inSameDayAs: now) {
            let slotMinuteOfDay = calendar.component(.hour, from: slotDate) * 60 + calendar.component(.minute, from: slotDate)
            let nowMinuteOfDay = calendar.component(.hour, from: now) * 60 + calendar.component(.minute, from: now)
            return slotMinuteOfDay <= nowMinuteOfDay
        }

        return slotDate < now
    }

    func slotKey(date: Date, timeLabel: String, barberName: String) -> String? {
        let cleanedBarberName = barberName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanedBarberName.isEmpty else { return nil }

        do {
            let slotStartAt = try makeSlotDate(date: date, timeLabel: timeLabel)
            let barberId = normalizedBarberId(from: cleanedBarberName)
            let dateKey = Self.dateKeyFormatter.string(from: slotStartAt)
            let time24 = Self.time24Formatter.string(from: slotStartAt)
            return makeSlotKey(barberId: barberId, dateKey: dateKey, time24: time24)
        } catch {
            return nil
        }
    }

    func fetchUserAppointments(email: String) async throws -> [UserAppointment] {
        let snapshot = try await db.collection(appointmentsCollection)
            .whereField("email", isEqualTo: email)
            .getDocuments()

        return snapshot.documents.compactMap { document in
            UserAppointment(id: document.documentID, data: document.data())
        }
        .sorted { $0.date > $1.date }
    }

    func deleteAppointment(_ appointment: UserAppointment) async throws {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let appointmentRef = db.collection(appointmentsCollection).document(appointment.id)
            let snapshot = try await appointmentRef.getDocument()
            let data = snapshot.data() ?? [:]

            let slotKeyFromDocument = data["slotKey"] as? String
            let knownSlotKey = slotKeyFromDocument ?? appointment.slotKey

            let batch = db.batch()
            batch.deleteDocument(appointmentRef)

            if let slotKey = knownSlotKey, !slotKey.isEmpty {
                let lockRef = db.collection(slotLocksCollection).document(slotKey)
                batch.deleteDocument(lockRef)
            } else {
                let lockSnapshot = try await db.collection(slotLocksCollection)
                    .whereField("appointmentId", isEqualTo: appointment.id)
                    .getDocuments()

                for lockDocument in lockSnapshot.documents {
                    batch.deleteDocument(lockDocument.reference)
                }
            }

            try await batch.commit()

            if let canonical = canonicalSlotKey(from: data, fallbackDocumentId: appointment.id) {
                bookedSlotKeys.remove(canonical)
            }

            if let slotKey = knownSlotKey, !slotKey.isEmpty {
                bookedSlotKeys.remove(slotKey)
            }
        } catch {
            errorMessage = AppointmentError.deletionFailed(error.localizedDescription).localizedDescription
            throw AppointmentError.deletionFailed(error.localizedDescription)
        }
    }

    func reset() {
        selectedCut = nil
        selectedDate = Date()
        selectedTime = ""
        customerName = ""
        customerEmail = ""
        notes = ""
        barberName = ""
        errorMessage = nil
        bookedSlotKeys = []
    }

    private func createBookingTransaction(
        lockRef: DocumentReference,
        appointmentRef: DocumentReference,
        legacyLockRef: DocumentReference?,
        legacyAppointmentRef: DocumentReference?,
        lockData: [String: Any],
        appointmentData: [String: Any]
    ) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            db.runTransaction({ transaction, errorPointer -> Any? in
                do {
                    let existingLock = try transaction.getDocument(lockRef)
                    if existingLock.exists {
                        errorPointer?.pointee = AppointmentError.slotAlreadyBooked.asNSError()
                        return nil
                    }

                    let existingAppointment = try transaction.getDocument(appointmentRef)
                    if existingAppointment.exists {
                        errorPointer?.pointee = AppointmentError.slotAlreadyBooked.asNSError()
                        return nil
                    }

                    if let legacyLockRef {
                        let existingLegacyLock = try transaction.getDocument(legacyLockRef)
                        if existingLegacyLock.exists {
                            errorPointer?.pointee = AppointmentError.slotAlreadyBooked.asNSError()
                            return nil
                        }
                    }

                    if let legacyAppointmentRef {
                        let existingLegacyAppointment = try transaction.getDocument(legacyAppointmentRef)
                        if existingLegacyAppointment.exists {
                            errorPointer?.pointee = AppointmentError.slotAlreadyBooked.asNSError()
                            return nil
                        }
                    }

                    transaction.setData(lockData, forDocument: lockRef)
                    transaction.setData(appointmentData, forDocument: appointmentRef)
                    return appointmentRef.documentID
                } catch {
                    errorPointer?.pointee = error as NSError
                    return nil
                }
            }, completion: { _, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            })
        }
    }

    private func normalizedBarberId(from barberName: String) -> String {
        barberName
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .replacingOccurrences(of: " ", with: "-")
    }

    private func makeSlotDate(date: Date, timeLabel: String) throws -> Date {
        guard let timeOnly = Self.timeLabelFormatter.date(from: timeLabel) else {
            throw AppointmentError.invalidSlot
        }

        let calendar = Calendar.current
        var dayComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: timeOnly)
        dayComponents.hour = timeComponents.hour
        dayComponents.minute = timeComponents.minute
        dayComponents.second = 0
        dayComponents.nanosecond = 0

        guard let slotDate = calendar.date(from: dayComponents) else {
            throw AppointmentError.invalidSlot
        }

        return slotDate
    }

    private func makeSlotKey(barberId: String, dateKey: String, time24: String) -> String {
        "\(barberId)_\(dateKey)_\(time24)"
    }

    private func makeLegacySlotKey(barberId: String, slotStartAt: Date) -> String {
        "\(barberId)_\(Int(slotStartAt.timeIntervalSince1970))"
    }

    private func canonicalSlotKey(from data: [String: Any], fallbackDocumentId: String) -> String? {
        guard let barberId = data["barberId"] as? String else { return nil }

        if let dateKey = data["dateKey"] as? String,
           let time24 = data["time24"] as? String {
            return makeSlotKey(barberId: barberId, dateKey: dateKey, time24: time24)
        }

        if let slotTimestamp = data["slotStartAt"] as? Timestamp {
            let slotStartAt = slotTimestamp.dateValue()
            let dateKey = Self.dateKeyFormatter.string(from: slotStartAt)
            let time24 = Self.time24Formatter.string(from: slotStartAt)
            return makeSlotKey(barberId: barberId, dateKey: dateKey, time24: time24)
        }

        if fallbackDocumentId.contains("_") {
            return fallbackDocumentId
        }
        return nil
    }

    private func isMissingIndexError(_ error: NSError) -> Bool {
        let lowered = error.localizedDescription.lowercased()
        return error.domain == FirestoreErrorDomain &&
            error.code == FirestoreErrorCode.failedPrecondition.rawValue &&
            lowered.contains("requires an index")
    }

    private func friendlyFirestoreMessage(for error: NSError) -> String {
        if isMissingIndexError(error) {
            return "Missing Firestore index for this query. Please create the suggested index in Firebase Console."
        }
        return error.localizedDescription
    }

    private static let timeLabelFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()

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

struct UserAppointment: Identifiable, Codable {
    let id: String
    let slotKey: String?
    let cutName: String
    let price: Double
    let barberName: String
    let time: String
    let date: Date
    let username: String
    let email: String

    init?(id: String, data: [String: Any]) {
        self.id = id
        self.slotKey = data["slotKey"] as? String

        let resolvedTime = (data["timeLabel"] as? String) ?? (data["time"] as? String)
        let resolvedDate: Date? = {
            if let timestamp = (data["slotStartAt"] as? Timestamp) ?? (data["date"] as? Timestamp) {
                return timestamp.dateValue()
            }
            if let dateKey = data["dateKey"] as? String,
               let time24 = data["time24"] as? String,
               let combinedDate = Self.dateTime24Formatter.date(from: "\(dateKey) \(time24)") {
                return combinedDate
            }
            return nil
        }()

        let resolvedUsername = (data["username"] as? String) ?? (data["userName"] as? String)

        guard
            let cutName = data["cutName"] as? String,
            let price = data["price"] as? Double,
            let barberName = data["barberName"] as? String,
            let time = resolvedTime,
            let date = resolvedDate,
            let username = resolvedUsername,
            let email = data["email"] as? String
        else { return nil }

        self.cutName = cutName
        self.price = price
        self.barberName = barberName
        self.time = time
        self.date = date
        self.username = username
        self.email = email
    }

    private static let dateTime24Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()
}

enum AppointmentError: LocalizedError {
    case noServiceSelected
    case missingBarber
    case invalidSlot
    case slotInPast
    case slotAlreadyBooked
    case bookingInProgress
    case bookingFailed(String)
    case deletionFailed(String)

    static let errorDomain = "AppointmentBooking"

    var code: Int {
        switch self {
        case .slotInPast:
            return 400
        case .slotAlreadyBooked:
            return 409
        default:
            return 500
        }
    }

    func asNSError() -> NSError {
        NSError(domain: Self.errorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: errorDescription ?? "Booking failed"])
    }

    var errorDescription: String? {
        switch self {
        case .noServiceSelected:
            return "Please select a service before booking."
        case .missingBarber:
            return "Please select a barber before booking."
        case .invalidSlot:
            return "Invalid date or time slot selected."
        case .slotInPast:
            return "You cannot book a time slot that has already passed."
        case .slotAlreadyBooked:
            return "This slot is already booked. Please choose another time."
        case .bookingInProgress:
            return "Booking is already in progress."
        case .bookingFailed(let message):
            return "Booking failed: \(message)"
        case .deletionFailed(let message):
            return "Delete failed: \(message)"
        }
    }
}
