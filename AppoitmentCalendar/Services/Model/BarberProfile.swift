import Foundation

struct BarberProfile: Identifiable, Hashable {
    let id: String
    let name: String
    let bio: String
    let imageName: String

    init(name: String, bio: String, imageName: String) {
        self.name = name
        self.bio = bio
        self.imageName = imageName
        self.id = BarberDirectory.normalizedBarberId(from: name)
    }
}

enum BarberDirectory {
    static let featured: [BarberProfile] = [
        BarberProfile(name: "Michael", bio: "Classic and modern cuts", imageName: "barber-1"),
        BarberProfile(name: "James", bio: "Fade specialist", imageName: "barber-2"),
        BarberProfile(name: "Daniel", bio: "Beard and grooming", imageName: "barber-3"),
        BarberProfile(name: "Chris", bio: "Fast and clean cuts", imageName: "barber-0")
    ]

    static func normalizedBarberId(from value: String) -> String {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .replacingOccurrences(of: " ", with: "-")
    }
}
