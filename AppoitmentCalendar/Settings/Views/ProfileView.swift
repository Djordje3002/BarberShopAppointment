import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var contentVM: ContentViewModel

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 72))
                .foregroundStyle(.blue)

            Text(contentVM.currentUser?.username ?? "Guest")
                .font(.title2.bold())

            Text(contentVM.currentUser?.email ?? "No email available")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding()
        .navigationTitle("Profile")
    }
}

#Preview {
    ProfileView()
        .environmentObject(ContentViewModel())
}
