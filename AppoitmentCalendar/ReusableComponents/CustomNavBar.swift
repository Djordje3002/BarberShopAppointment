import SwiftUI

struct CustomNavBar: View {
    @Environment(\.dismiss) private var dismiss

    let title: String

    var body: some View {
        HStack(spacing: 12) {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .clipShape(Circle())
            }

            Text(title)
                .font(.headline)

            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

#Preview {
    NavigationStack {
        CustomNavBar(title: "Example")
    }
}
