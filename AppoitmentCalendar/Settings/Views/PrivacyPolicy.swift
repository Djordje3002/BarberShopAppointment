import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            Text("We store only the data required to authenticate users and manage appointments. Contact the shop to request data removal.")
                .padding()
        }
        .navigationTitle("Privacy Policy")
    }
}

#Preview {
    PrivacyPolicyView()
}
