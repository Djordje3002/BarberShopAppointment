//
//  CreateUsernameView.swift
//  InstagramTutorial
//
//  Created by Djordje on 23. 6. 2025..
//

import SwiftUI

struct CreateUsernameView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var router: NavigationRouter

    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 12) {
                Text("Pick a username")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("This is how you'll be identified in the shop.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 40)

            // Input
            VStack(spacing: 16) {
                CustomTextField(iconName: "person", placeholder: "Username", text: $viewModel.username)
                    .autocapitalization(.none)
            }
            
            // Next Button
            Button {
                router.push(.phoneNumber)
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
}

#Preview {
    NavigationStack {
        CreateUsernameView()
            .environmentObject(RegistrationViewModel())
    }
}
