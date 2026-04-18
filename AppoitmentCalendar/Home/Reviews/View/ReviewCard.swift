import SwiftUI

struct ReviewCard: View {
    let review: Review

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Text(review.author)
                    .font(.headline)

                Spacer()

                HStack(spacing: 3) {
                    ForEach(0..<5, id: \.self) { index in
                        Image(systemName: index < review.rating ? "star.fill" : "star")
                            .font(.title3.weight(.bold))
                            .foregroundStyle(index < review.rating ? .yellow : .gray.opacity(0.35))
                    }
                }
            }

            Text(review.message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

#Preview {
    ReviewCard(review: Review(author: "Mark", message: "Great fade and very friendly team.", rating: 5))
        .padding()
}
