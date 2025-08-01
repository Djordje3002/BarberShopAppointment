import Foundation
import FirebaseFirestore

struct Appointment: Codable, Identifiable {
    var id: String = UUID().uuidString
    var barberName: String
    var haircut: HaircutType
    var date: Date
    var time: String

    var price: Double {
        haircut.price
    }

    var dictionary: [String: Any] {
        return [
            "id": id,
            "barberName": barberName,
            "haircut": haircut.rawValue,
            "price": haircut.price,
            "date": Timestamp(date: date),
            "time": time
        ]
    }

    init(id: String = UUID().uuidString, barberName: String, haircut: HaircutType, date: Date, time: String) {
        self.id = id
        self.barberName = barberName
        self.haircut = haircut
        self.date = date
        self.time = time
    }

    init?(from data: [String: Any]) {
        guard
            let id = data["id"] as? String,
            let barberName = data["barberName"] as? String,
            let haircutRaw = data["haircut"] as? String,
            let haircut = HaircutType(rawValue: haircutRaw),
            let timestamp = data["date"] as? Timestamp,
            let time = data["time"] as? String
        else {
            return nil
        }

        self.id = id
        self.barberName = barberName
        self.haircut = haircut
        self.date = timestamp.dateValue()
        self.time = time
    }
}

