import SwiftUI

struct AddPhoneNumber: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var registrationViewModel: RegistrationViewModel

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
                    .autocapitalization(.none)
                    .modifier(IGTextFieldModifier())
                    .padding(.top)
            }
            
            NavigationLink {
                CompleteSignUpView()
                    .environmentObject(registrationViewModel)
                    .navigationBarBackButtonHidden()
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
}

#Preview {
    NavigationStack {
        AddPhoneNumber()
            .environmentObject(RegistrationViewModel())
    }
}


