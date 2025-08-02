import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LogInViewModel()
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var registrationViewModel: RegistrationViewModel
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                Image("barber-0")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 220, height: 120)
                    .clipped()
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                    .padding(.bottom, 32)

                VStack {
                    TextField("Enter your email: ", text: $viewModel.email)
                        .autocapitalization(.none)
                        .modifier(IGTextFieldModifier())

                    SecureField("Enter your password: ", text: $viewModel.password)
                        .modifier(IGTextFieldModifier())
                }

                Button {
                    Task {
                            try await authViewModel.login(email: viewModel.email, password: viewModel.password)
                        }
                } label: {
                    Text("Log In")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue)
                        )
                        .padding(.horizontal)
                        .padding(.top)
                }

                Spacer()
                Divider()

                NavigationLink {
                    AddEmailView()
                        .environmentObject(registrationViewModel)
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                        Text("Sign Up")
                            .fontWeight(.semibold)
                    }
                    .font(.footnote)
                }
                .padding(.vertical)
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(NavigationRouter())
        .environmentObject(RegistrationViewModel())
}
