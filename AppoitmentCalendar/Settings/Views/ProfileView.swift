import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var contentVM: ContentViewModel
    @State private var username: String = ""
    @State private var phoneNumber: String = ""
    @State private var isEditing = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Profile Header
                VStack(spacing: 16) {
                    ZStack(alignment: .bottomTrailing) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .foregroundStyle(.blue.gradient)
                            .background(Circle().fill(Color(.systemGray6)))
                        
                        if isEditing {
                            Image(systemName: "camera.fill")
                                .padding(8)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        }
                    }
                    
                    VStack(spacing: 4) {
                        Text(contentVM.currentUser?.username ?? "Guest")
                            .font(.title2.bold())
                        Text(contentVM.currentUser?.email ?? "No email")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.top, 20)

                // Info Sections
                VStack(spacing: 24) {
                    InfoField(label: "Username", text: $username, isEditable: isEditing, icon: "person")
                    InfoField(label: "Phone Number", text: $phoneNumber, isEditable: isEditing, icon: "phone", keyboardType: .phonePad)
                    InfoField(label: "Email", text: .constant(contentVM.currentUser?.email ?? ""), isEditable: false, icon: "envelope")
                }
                .padding(.horizontal)

                Spacer()
                
                // Action Buttons
                VStack(spacing: 16) {
                    if isEditing {
                        Button {
                            saveChanges()
                        } label: {
                            Text("Save Changes")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                                .background(Color.blue)
                                .cornerRadius(16)
                        }
                        
                        Button {
                            withAnimation {
                                isEditing = false
                                resetFields()
                            }
                        } label: {
                            Text("Cancel")
                                .font(.headline)
                                .foregroundColor(.red)
                        }
                    } else {
                        Button {
                            withAnimation {
                                isEditing = true
                            }
                        } label: {
                            Text("Edit Profile")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                                .background(Color.primary)
                                .cornerRadius(16)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 30)
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            resetFields()
        }
        .alert("Update Profile", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }

    private func resetFields() {
        username = contentVM.currentUser?.username ?? ""
        phoneNumber = contentVM.currentUser?.phoneNumber ?? ""
    }

    private func saveChanges() {
        Task {
            do {
                try await AuthService.shared.updateUserData(username: username, phoneNumber: phoneNumber)
                alertMessage = "Your profile has been updated successfully."
                showAlert = true
                isEditing = false
            } catch {
                alertMessage = "Failed to update profile: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }
}

struct InfoField: View {
    let label: String
    @Binding var text: String
    let isEditable: Bool
    let icon: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .padding(.leading, 4)

            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 24)

                if isEditable {
                    TextField(label, text: $text)
                        .keyboardType(keyboardType)
                        .font(.body)
                } else {
                    Text(text.isEmpty ? "Not provided" : text)
                        .font(.body)
                        .foregroundColor(text.isEmpty ? .secondary : .primary)
                }
                
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isEditable ? Color.blue.opacity(0.3) : Color.clear, lineWidth: 1)
            )
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(ContentViewModel())
}
