import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

@MainActor
final class BarberAccountSeeder: ObservableObject {
    @Published var isSeeding = false
    @Published var statusMessage: String?
    @Published var errorMessage: String?

    private let db = Firestore.firestore()
    private let secondaryAppName = "barber-seeder"

    func seedDefaultBarberAccounts() async {
        guard !isSeeding else { return }
        isSeeding = true
        statusMessage = nil
        errorMessage = nil
        defer { isSeeding = false }

        do {
            let auth = try seederAuth()
            var successCount = 0
            var failures: [String] = []

            for account in BarberSeedCatalog.accounts {
                do {
                    let uid = try await ensureAccount(auth: auth, account: account)
                    try await upsertUserDocument(uid: uid, account: account)
                    successCount += 1
                } catch {
                    failures.append("\(account.email): \(error.localizedDescription)")
                }
            }

            try? auth.signOut()

            if failures.isEmpty {
                statusMessage = "Created/updated \(successCount) barber accounts."
            } else {
                errorMessage = "Some accounts failed:\n\n\(failures.joined(separator: "\n"))"
                statusMessage = "Completed with \(failures.count) issue(s)."
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func seederAuth() throws -> Auth {
        if let app = FirebaseApp.app(name: secondaryAppName) {
            return Auth.auth(app: app)
        }

        guard let defaultApp = FirebaseApp.app() else {
            throw SeederError.firebaseNotConfigured
        }

        FirebaseApp.configure(name: secondaryAppName, options: defaultApp.options)

        guard let app = FirebaseApp.app(name: secondaryAppName) else {
            throw SeederError.failedToCreateSecondaryApp
        }

        return Auth.auth(app: app)
    }

    private func ensureAccount(auth: Auth, account: BarberSeedAccount) async throws -> String {
        do {
            let result = try await auth.createUser(withEmail: account.email, password: account.password)
            return result.user.uid
        } catch {
            let nsError = error as NSError
            guard nsError.code == AuthErrorCode.emailAlreadyInUse.rawValue else {
                throw error
            }

            do {
                let result = try await auth.signIn(withEmail: account.email, password: account.password)
                return result.user.uid
            } catch {
                throw SeederError.existingAccountPasswordMismatch(email: account.email)
            }
        }
    }

    private func upsertUserDocument(uid: String, account: BarberSeedAccount) async throws {
        let data: [String: Any] = [
            "id": uid,
            "username": account.name,
            "email": account.email,
            "role": "barber",
            "barberId": account.barberId,
            "updatedAt": FieldValue.serverTimestamp()
        ]

        try await db.collection("users").document(uid).setData(data, merge: true)
    }
}

enum SeederError: LocalizedError {
    case firebaseNotConfigured
    case failedToCreateSecondaryApp
    case existingAccountPasswordMismatch(email: String)

    var errorDescription: String? {
        switch self {
        case .firebaseNotConfigured:
            return "Firebase is not configured in the app yet."
        case .failedToCreateSecondaryApp:
            return "Failed to initialize secondary Firebase app for seeding."
        case .existingAccountPasswordMismatch(let email):
            return "Account \(email) already exists with a different password. Delete it in Firebase Auth or update the seed password."
        }
    }
}
