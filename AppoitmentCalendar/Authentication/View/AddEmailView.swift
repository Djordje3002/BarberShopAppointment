import SwiftUI

struct AddEmailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    @EnvironmentObject var router: NavigationRouter
    
    @State private var showEmailError = false
    @State private var emailErrorMessage = ""
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Add your email")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            
            VStack {
                Text("You will use this email to sign in to your account")
                    .font(.footnote)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                TextField("Email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .modifier(IGTextFieldModifier())
                    .padding(.top)
                    .keyboardType(.emailAddress)
                
                if showEmailError {
                    Text(emailErrorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                        .padding(.horizontal, 24)
                }
            }
            
            Button {
                isLoading = true
                if isValidEmail(viewModel.email) {
                    showEmailError = false
                    router.push(.createPassword)
                    isLoading = false
                } else {
                    showEmailError = true
                    emailErrorMessage = "Please enter a valid email address"
                    isLoading = false
                }
            } label: {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Next")
                        .modifier(MainButtonModifier())
                }
            }
            .disabled(isLoading)
            
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
    
    // Email validation function
    func isValidEmail(_ email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
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
