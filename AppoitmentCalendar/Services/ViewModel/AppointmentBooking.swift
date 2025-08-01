import Foundation
import SwiftUI
import FirebaseFirestore

class AppointmentBooking: ObservableObject {
    
    @Published var selectedCut: HaircutOption?
    @Published var selectedDate: Date = Date()
    @Published var selectedTime: String = ""
    @Published var customerName: String = ""
    @Published var customerEmail: String = ""
    @Published var notes: String = ""
    @Published var barberName: String = ""
    
    // Save to Firestore
    func bookAppointment(completion: @escaping () -> Void = {}) {
        let db = Firestore.firestore()

        guard let selectedCut = selectedCut else {
            print("❌ No selected cut")
            return
        }

        let data: [String: Any] = [
            "cutName": selectedCut.name,
            "price": selectedCut.price,
            "barberName": barberName,
            "time": selectedTime,
            "date": Timestamp(date: selectedDate)
        ]

        db.collection("appointments").addDocument(data: data) { error in
            if let error = error {
                print("❌ Firebase error:", error.localizedDescription)
            } else {
                print("✅ Appointment saved with:", data)
                completion()
            }
        }
    }

    // Optional: reset form after booking
    func reset() {
        selectedDate = Date()
        selectedTime = ""
        customerName = ""
        customerEmail = ""
        notes = ""
    }
}
