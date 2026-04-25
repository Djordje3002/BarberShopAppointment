import SwiftUI

struct CompleteSignUpView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    @EnvironmentObject var router: NavigationRouter
    
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Welcome Section
            VStack(spacing: 16) {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(.green)
                    .symbolEffect(.bounce, value: isLoading)
                
                Text("Welcome, \(viewModel.username)!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                Text("Your account is almost ready. Tap below to finish and start booking your next cut.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            if showError {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.top, 4)
            }
            
            // Complete Button
            Button {
                isLoading = true
                Task {
                    do {
                        try await viewModel.createUser()
                        isLoading = false
                        // router.push(.home) // Removed as createUser might trigger auth state change handled by AuthRootView
                    } catch {
                        isLoading = false
                        showError = true
                        errorMessage = error.localizedDescription
                    }
                }
            } label: {
                Group {
                    if isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Complete Registration")
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
}

#Preview {
    NavigationStack {
        CompleteSignUpView()
            .environmentObject(RegistrationViewModel())
            .environmentObject(NavigationRouter())
            .environmentObject(AppointmentBooking())
    }
}
