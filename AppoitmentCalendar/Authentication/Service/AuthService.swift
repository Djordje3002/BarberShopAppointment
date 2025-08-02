import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

@MainActor
class AuthService {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?

    static let shared = AuthService()
    
    init() {
        Task {
            try await loadUserData()
        }
    }
    
    func login(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            await MainActor.run {
                self.userSession = result.user
            }
            try await loadUserData()
        } catch {
            print("Failed to log in user: \(error.localizedDescription)")
        }
    }
    
    func createUser(email: String, password: String, username: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            await MainActor.run {
                self.userSession = result.user
            }
            await uploadUserData(uid: result.user.uid, username: username, email: email)
        } catch {
            print("Failed to register user: \(error.localizedDescription)")
        }
    }
    
    func loadUserData() async throws {
        self.userSession = Auth.auth().currentUser
        guard let currentUid = userSession?.uid else { return }

        let snapshot = try await Firestore.firestore().collection("users").document(currentUid).getDocument()
        let user = try? snapshot.data(as: User.self)

        await MainActor.run {
            self.currentUser = user
        }
    }
    
    func signoOut() async throws {
        try? Auth.auth().signOut()
        await MainActor.run {
            self.userSession = nil
            self.currentUser = nil
        }
    }
    
    private func uploadUserData(uid: String, username: String, email: String) async {
        let user = User(id: uid, username: username, email: email)
        await MainActor.run {
            self.currentUser = user
        }

        guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
        try? await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
    }
}

