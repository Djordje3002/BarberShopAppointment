import SwiftUI

struct CreatePasswordView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var registrationViewModel: RegistrationViewModel

    @State private var showPasswordError = false
    @State private var passwordErrorMessage = ""

    var body: some View {
        VStack(spacing: 12) {
            Text("Create password")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)

            VStack {
                Text("Your password must be at least 6 characters long")
                    .font(.footnote)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                SecureField("Password", text: $viewModel.password)
                    .autocapitalization(.none)
                    .modifier(IGTextFieldModifier())
                    .padding(.top)

                if showPasswordError {
                    Text(passwordErrorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.top)
                        .padding(.horizontal, 32)
                }
            }

            Button {
                if isValidPassword(viewModel.password) {
                    showPasswordError = false
                    router.push(.userName)
                } else {
                    showPasswordError = true
                    passwordErrorMessage = "Password must be at least 6 characters, contain a letter, a number, and a special character."
                }
            } label: {
                Text("Next")
                    .modifier(MainButtonModifier())
            }

            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .onTapGesture {
                        dismiss()
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
