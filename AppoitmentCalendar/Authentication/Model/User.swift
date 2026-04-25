import Foundation

enum UserRole: String, Codable {
    case client
    case barber
}

struct User: Identifiable, Codable {
    let id: String
    var username: String
    var email: String?
    var phoneNumber: String?
    var role: UserRole
    var barberId: String?

    init(
        id: String,
        username: String,
        email: String?,
        phoneNumber: String? = nil,
        role: UserRole = .client,
        barberId: String? = nil
    ) {
        self.id = id
        self.username = username
        self.email = email
        self.phoneNumber = phoneNumber
        self.role = role
        self.barberId = barberId
    }

    var isBarber: Bool {
        role == .barber
    }

    var resolvedBarberId: String? {
        let cleanedBarberId = barberId?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !cleanedBarberId.isEmpty {
            return cleanedBarberId.normalizedBarberId()
        }
        guard isBarber else { return nil }
        return username.normalizedBarberId()
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case phoneNumber
        case role
        case barberId
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)

        if let rawRole = try container.decodeIfPresent(String.self, forKey: .role)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased(),
           let decodedRole = UserRole(rawValue: rawRole) {
            role = decodedRole
        } else {
            role = .client
        }

        barberId = try container.decodeIfPresent(String.self, forKey: .barberId)
    }

}
