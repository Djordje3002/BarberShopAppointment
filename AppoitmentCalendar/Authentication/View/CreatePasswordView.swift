import SwiftUI

struct CreatePasswordView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var router: NavigationRouter

    @State private var showPasswordError = false
    @State private var passwordErrorMessage = ""

    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 12) {
                Text("Secure your account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Choose a strong password with at least 6 characters.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            .padding(.top, 40)

            // Input
            VStack(alignment: .leading, spacing: 12) {
                CustomTextField(iconName: "lock", placeholder: "Password", isSecure: true, text: $viewModel.password)
                    .autocapitalization(.none)

                if showPasswordError {
                    Text(passwordErrorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal, 28)
                }
            }

            // Next Button
            Button {
                if isValidPassword(viewModel.password) {
                    showPasswordError = false
                    router.push(.userName)
                } else {
                    showPasswordError = true
                    passwordErrorMessage = "Password must be at least 6 characters, contain a letter, a number, and a special character."
                }
            } label: {
                Text("Continue")
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

    func isValidPassword(_ password: String) -> Bool {
        let minLengthRequirement = password.count >= 6
        let containsLetter = password.range(of: "[A-Za-z]", options: .regularExpression) != nil
        let containsNumber = password.range(of: "\\d", options: .regularExpression) != nil
        let containsSpecialChar = password.range(of: "[!@#$%^&*(),.?\":{}|<>]", options: .regularExpression) != nil

        return minLengthRequirement && containsLetter && containsNumber && containsSpecialChar
    }
}

#Preview {
    NavigationStack {
        CreatePasswordView()
            .environmentObject(RegistrationViewModel())
    }
}
