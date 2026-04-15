import Foundation

enum UserRole: String, Codable {
    case client
    case barber
}

struct User: Identifiable, Codable {
    let id: String
    let username: String
    let email: String?
    let role: UserRole
    let barberId: String?

    init(
        id: String,
        username: String,
        email: String?,
        role: UserRole = .client,
        barberId: String? = nil
    ) {
        self.id = id
        self.username = username
        self.email = email
        self.role = role
        self.barberId = barberId
    }

    var isBarber: Bool {
        role == .barber
    }

    var resolvedBarberId: String? {
        let cleanedBarberId = barberId?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !cleanedBarberId.isEmpty {
            return Self.normalizedBarberId(from: cleanedBarberId)
        }
        guard isBarber else { return nil }
        return Self.normalizedBarberId(from: username)
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case role
        case barberId
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        email = try container.decodeIfPresent(String.self, forKey: .email)

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

    private static func normalizedBarberId(from value: String) -> String {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .replacingOccurrences(of: " ", with: "-")
    }
}
