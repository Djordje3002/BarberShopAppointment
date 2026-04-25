import SwiftUI

struct AddPhoneNumber: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    @EnvironmentObject var router: NavigationRouter

    @State private var showPhoneError = false
    @State private var phoneErrorMessage = ""

    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 12) {
                Text("Phone number")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("We'll use this to contact you about your appointments.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            .padding(.top, 40)

            // Input
            VStack(alignment: .leading, spacing: 12) {
                CustomTextField(iconName: "phone", placeholder: "Phone Number", text: $viewModel.phoneNumber)
                    .keyboardType(.numberPad)

                if showPhoneError {
                    Text(phoneErrorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal, 28)
                }
            }

            // Next Button
            Button {
                if isValidPhoneNumber(viewModel.phoneNumber) {
                    showPhoneError = false
                    router.push(.completeSignUp)
                } else {
                    showPhoneError = true
                    phoneErrorMessage = "Please enter a valid phone number"
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

    /// Basic phone validation (digits only, length 7–15)
    func isValidPhoneNumber(_ number: String) -> Bool {
        let phoneRegex = #"^\+?[0-9]{7,15}$"#
        return number.range(of: phoneRegex, options: .regularExpression) != nil
    }
}

#Preview {
    NavigationStack {
        AddPhoneNumber()
            .environmentObject(RegistrationViewModel())
    }
}
