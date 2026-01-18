import SwiftUI

struct CompleteSignUpView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    @EnvironmentObject var router: NavigationRouter
    
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            
            Text("Welcome to Barber App, \(viewModel.username)")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
                .padding(.horizontal, 24)
                .multilineTextAlignment(.center)
            
            Text("Click below to complete registration and start booking")
                .font(.footnote)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            if showError {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.top, 4)
            }
            
            Button {
                isLoading = true
                Task {
                    do {
                        try await viewModel.createUser()
                        isLoading = false
                        router.push(.home) // Navigate to home screen on success
                    } catch {
                        isLoading = false
                        showError = true
                        errorMessage = error.localizedDescription
                    }
                }
            } label: {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Complete Sign Up")
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
}

#Preview {
    NavigationStack {
        CompleteSignUpView()
            .environmentObject(RegistrationViewModel())
            .environmentObject(NavigationRouter())
            .environmentObject(AppointmentBooking())
    }
}
