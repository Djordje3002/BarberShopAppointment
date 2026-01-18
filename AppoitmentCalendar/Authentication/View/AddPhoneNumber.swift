import SwiftUI

struct AddPhoneNumber: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var registrationViewModel: RegistrationViewModel

    @State private var showPhoneError = false
    @State private var phoneErrorMessage = ""

    var body: some View {
        VStack(spacing: 12) {
            Text("Add your phone number")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)

            VStack {
                Text("We will call you if needed")
                    .font(.footnote)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)

                TextField("Phone Number", text: $viewModel.phoneNumber)
                    .keyboardType(.numberPad)
                    .modifier(IGTextFieldModifier())
                    .padding(.top)

                if showPhoneError {
                    Text(phoneErrorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.top, 4)
                }
            }

            Button {
                if isValidPhoneNumber(viewModel.phoneNumber) {
                    showPhoneError = false
                    router.push(.completeSignUp)
                } else {
                    showPhoneError = true
                    phoneErrorMessage = "Please enter a valid phone number"
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
