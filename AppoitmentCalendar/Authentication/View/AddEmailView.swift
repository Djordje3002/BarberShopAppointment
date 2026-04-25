import SwiftUI

struct AddEmailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel

    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 12) {
                Image("barber-0")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)

                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Fill in all details below to get started.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 20)

            VStack(spacing: 14) {
                CustomTextField(iconName: "envelope", placeholder: "Email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)

                CustomTextField(iconName: "lock", placeholder: "Password", isSecure: true, text: $viewModel.password)
                    .autocapitalization(.none)

                CustomTextField(iconName: "person", placeholder: "Username", text: $viewModel.username)
                    .autocapitalization(.none)

                PhoneNumberField(phoneNumber: $viewModel.phoneNumber)

                if let errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
            }

            Button {
                register()
            } label: {
                Group {
                    if isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.primary)
                )
                .padding(.horizontal)
            }
            .disabled(isLoading)

            Spacer()
        }
        .background(Color(.systemBackground))
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                }
            }
        }
    }

    private func register() {
        if let validationError = validateInputs() {
            errorMessage = validationError
            return
        }

        errorMessage = nil
        isLoading = true

        Task {
            do {
                try await viewModel.createUser()
                viewModel.reset()
                isLoading = false
            } catch {
                errorMessage = "Sign up failed: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }

    private func validateInputs() -> String? {
        if !isValidEmail(viewModel.email) {
            return "Please enter a valid email address."
        }

        if !isValidPassword(viewModel.password) {
            return "Password must have at least 6 characters with a letter, number, and special character."
        }

        if viewModel.username.trimmingCharacters(in: .whitespacesAndNewlines).count < 2 {
            return "Username must be at least 2 characters."
        }

        if !isValidPhoneNumber(viewModel.phoneNumber) {
            return "Please enter a valid phone number."
        }

        return nil
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        let minLengthRequirement = password.count >= 6
        let containsLetter = password.range(of: "[A-Za-z]", options: .regularExpression) != nil
        let containsNumber = password.range(of: "\\d", options: .regularExpression) != nil
        let containsSpecialChar = password.range(of: "[!@#$%^&*(),.?\":{}|<>]", options: .regularExpression) != nil
        return minLengthRequirement && containsLetter && containsNumber && containsSpecialChar
    }

    private func isValidPhoneNumber(_ number: String) -> Bool {
        let phoneRegex = #"^\+?[0-9]{7,15}$"#
        return number.range(of: phoneRegex, options: .regularExpression) != nil
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        AddEmailView()
            .environmentObject(RegistrationViewModel())
            .environmentObject(NavigationRouter())
            .environmentObject(AppointmentBooking())
    }
}
