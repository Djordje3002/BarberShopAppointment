import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published var errorMessage: String?
    private let service = AuthService.shared
    
    func login(email: String, password: String) async throws {
        do {
            try await service.login(email: email, password: password)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            throw error
        }
    }

    func logout() async throws {
        do {
            try await service.signOut()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            throw error
        }
    }
}
