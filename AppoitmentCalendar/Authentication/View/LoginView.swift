import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var registrationViewModel: RegistrationViewModel
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // Logo Section
            VStack(spacing: 12) {
                Image("barber-0")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 140, height: 140)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                Text("Barber Shop")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Text("Book your next style in seconds.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 20)

            // Input Section
            VStack(spacing: 16) {
                CustomTextField(iconName: "envelope", placeholder: "Email", text: $email)
                    .autocapitalization(.none)

                CustomTextField(iconName: "lock", placeholder: "Password", isSecure: true, text: $password)
                
                if let errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }
            }

            // Login Button
            Button {
                Task {
                    do {
                        try await authViewModel.login(email: email, password: password)
                    } catch {
                        errorMessage = "Login failed: \(error.localizedDescription)"
                    }
                }
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.primary)
                    )
                    .padding(.horizontal)
            }
            .padding(.top, 8)

            Spacer()
            
            // Footer Section
            VStack(spacing: 16) {
                Divider()
                    .padding(.horizontal, 40)
                
                Button {
                    registrationViewModel.reset()
                    router.push(.addEmail)
                } label: {
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .foregroundStyle(.secondary)
                        Text("Sign Up")
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                    }
                    .font(.footnote)
                }
            }
            .padding(.bottom, 24)
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    LoginView()
        .environmentObject(NavigationRouter())
        .environmentObject(RegistrationViewModel())
}
