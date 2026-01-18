import Foundation
import SwiftUI
import FirebaseFirestore

@MainActor
class AppointmentBooking: ObservableObject {
    
    @Published var selectedCut: HaircutOption?
    @Published var selectedDate: Date = Date()
    @Published var selectedTime: String = ""
    @Published var customerName: String = ""
    @Published var customerEmail: String = ""
    @Published var notes: String = ""
    @Published var barberName: String = ""
    
    // Error handling and loading state
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    // Save to Firestore with async/await
    func bookAppointment(currentUser: User) async throws {
        guard let selectedCut = selectedCut else {
            throw AppointmentError.noServiceSelected
        }
        
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        let db = Firestore.firestore()

        let data: [String: Any] = [
            "cutName": selectedCut.name,
            "price": selectedCut.price,
            "barberName": barberName,
            "time": selectedTime,
            "date": Timestamp(date: selectedDate),
            "username": currentUser.username,
            "email": currentUser.email ?? "Email is not inserted",
            "timestamp": Timestamp(date: Date())
        ]

        do {
            try await db.collection("appointments").addDocument(data: data)
            print("✅ Appointment saved successfully")
        } catch {
            errorMessage = "Failed to book appointment: \(error.localizedDescription)"
            print("❌ Firebase error:", error.localizedDescription)
            throw AppointmentError.bookingFailed(error.localizedDescription)
        }
    }

    // Fetch booked times for specific date and barber
    func fetchBookedTimes(date: Date, barberName: String) async throws -> [String] {
        let db = Firestore.firestore()
        let snapshot = try await db.collection("appointments")
            .whereField("barberName", isEqualTo: barberName)
            .whereField("date", isEqualTo: Timestamp(date: date))
            .getDocuments()
        
        return snapshot.documents.compactMap { $0.data()["time"] as? String }
    }
    
    // Fetch appointments for current user
    func fetchUserAppointments(email: String) async throws -> [Appointment] {
        let db = Firestore.firestore()
        let snapshot = try await db.collection("appointments")
            .whereField("email", isEqualTo: email)
            .order(by: "timestamp", descending: true)
            .getDocuments()
            
        return snapshot.documents.compactMap { doc -> Appointment? in
            let data = doc.data()
            return Appointment(id: doc.documentID, data: data)
        }
    }

    // Reset form after booking
    func reset() {
        selectedCut = nil
        selectedDate = Date()
        selectedTime = ""
        customerName = ""
        customerEmail = ""
        notes = ""
        barberName = ""
        errorMessage = nil
    }
}

struct Appointment: Identifiable, Codable {
    let id: String
    let cutName: String
    let price: Double
    let barberName: String
    let time: String
    let date: Date
    let username: String
    let email: String
    
    init?(id: String, data: [String: Any]) {
        self.id = id
        guard
            let cutName = data["cutName"] as? String,
            let price = data["price"] as? Double,
            let barberName = data["barberName"] as? String,
            let time = data["time"] as? String,
            let timestamp = data["date"] as? Timestamp,
            let username = data["username"] as? String,
            let email = data["email"] as? String
        else { return nil }
        
        self.cutName = cutName
        self.price = price
        self.barberName = barberName
        self.time = time
        self.date = timestamp.dateValue()
        self.username = username
        self.email = email
    }
}

// Custom error types for better error handling
enum AppointmentError: LocalizedError {
    case noServiceSelected
    case bookingFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .noServiceSelected:
            return "Please select a service before booking."
        case .bookingFailed(let message):
            return "Booking failed: \(message)"
        }
    }
}
