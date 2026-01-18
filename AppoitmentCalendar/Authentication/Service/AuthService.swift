import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

@MainActor
class AuthService {
    
    @Published var userSession: FirebaseAuth.User? = Auth.auth().currentUser
    @Published var currentUser: User?

    static let shared = AuthService()
    
    init() {
        Task {
            do {
                try await loadUserData()
            } catch {
                print("DEBUG: Failed to load user data - \(error.localizedDescription)")
            }
        }
    }
    
    func login(email: String, password: String) async throws {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        await MainActor.run {
            self.userSession = result.user
        }
        try await loadUserData()
    }
    
    func createUser(email: String, password: String, username: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        await MainActor.run {
            self.userSession = result.user
        }
        await uploadUserData(uid: result.user.uid, username: username, email: email)
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
    
    func signOut() async throws {
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

