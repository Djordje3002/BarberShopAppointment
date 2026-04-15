import Combine
import FirebaseAuth
import Foundation

@MainActor
final class ContentViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?

    private let service: AuthService
    private var cancellables = Set<AnyCancellable>()

    init(service: AuthService = .shared) {
        self.service = service
        self.userSession = service.userSession
        self.currentUser = service.currentUser

        service.$userSession
            .receive(on: DispatchQueue.main)
            .sink { [weak self] session in
                self?.userSession = session
            }
            .store(in: &cancellables)

        service.$currentUser
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.currentUser = user
            }
            .store(in: &cancellables)
    }

    func refreshUser() async {
        do {
            try await service.loadUserData()
        } catch {
            print("DEBUG: Failed to refresh user data - \(error.localizedDescription)")
        }
    }
}
