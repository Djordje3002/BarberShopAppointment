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
        self.id = name.normalizedBarberId()
    }
}

enum BarberDirectory {
    static let featured: [BarberProfile] = [
        BarberProfile(name: "Michael", bio: "Classic and modern cuts", imageName: "barber-1"),
        BarberProfile(name: "James", bio: "Fade specialist", imageName: "barber-2"),
        BarberProfile(name: "Daniel", bio: "Beard and grooming", imageName: "barber-3"),
        BarberProfile(name: "Chris", bio: "Fast and clean cuts", imageName: "barber-0")
    ]

}

struct BarberSeedAccount: Identifiable, Hashable {
    let id: String
    let name: String
    let barberId: String
    let email: String
    let password: String
}

enum BarberSeedCatalog {
    static let defaultPassword = "Barber#2026!"

    static let accounts: [BarberSeedAccount] = BarberDirectory.featured.map { barber in
        BarberSeedAccount(
            id: barber.id,
            name: barber.name,
            barberId: barber.id,
            email: "\(barber.id)@barberapp.com",
            password: defaultPassword
        )
    }
}
