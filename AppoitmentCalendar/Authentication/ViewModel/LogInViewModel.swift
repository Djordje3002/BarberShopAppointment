import Foundation

class LogInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?

    func signIn() async throws {
        try await AuthService.shared.login(email: email, password: password)
    }
}

