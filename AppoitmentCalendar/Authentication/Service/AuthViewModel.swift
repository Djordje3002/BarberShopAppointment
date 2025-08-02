import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    private let service = AuthService.shared
    
    func login(email: String, password: String) async throws {
        try await service.login(email: email, password: password)
    }

    func logout() async throws {
        try await service.signoOut()
    }
}
