import SwiftUI

struct ReviewCard: View {
    let review: Review

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(review.author)
                    .font(.headline)
                Spacer()
                Text(String(repeating: "*", count: review.rating))
                    .foregroundStyle(.yellow)
            }
            Text(review.message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

#Preview {
    ReviewCard(review: Review(author: "Mark", message: "Great fade and very friendly team.", rating: 5))
        .padding()
}
