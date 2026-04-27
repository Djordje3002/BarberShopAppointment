import SwiftUI

struct NewsCard: View {
    let item: NewsModel
    var isFeatured: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            media

            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    categoryPill
                    Text(Self.dateFormatter.string(from: item.date))
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                }

                Text(item.title)
                    .font(.system(size: isFeatured ? 22 : 19, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.11, green: 0.16, blue: 0.24))
                    .lineLimit(isFeatured ? 3 : 2)

                Text(item.subtitle)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Color(red: 0.33, green: 0.40, blue: 0.50))
                    .lineLimit(isFeatured ? 3 : 2)

                HStack {
                    Text("Read Story")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 0.10, green: 0.53, blue: 0.86))

                    Spacer()

                    Image(systemName: "arrow.right")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Color(red: 0.10, green: 0.53, blue: 0.86))
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white.opacity(0.90))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.white.opacity(0.80), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: Color.black.opacity(0.08), radius: 14, x: 0, y: 8)
    }

    @ViewBuilder
    private var media: some View {
        if let imageName = item.imageName {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: isFeatured ? 200 : 145)
                .frame(maxWidth: .infinity)
                .clipped()
                .overlay(
                    LinearGradient(
                        colors: [Color.black.opacity(0.02), Color.black.opacity(0.22)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        } else {
            LinearGradient(
                colors: [
                    Color(red: 0.91, green: 0.95, blue: 1.00),
                    Color(red: 0.99, green: 0.94, blue: 0.88)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: isFeatured ? 190 : 135)
            .frame(maxWidth: .infinity)
            .overlay(
                Image(systemName: "newspaper.fill")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(Color.white.opacity(0.85))
            )
        }
    }

    private var categoryPill: some View {
        Text(item.category.uppercased())
            .font(.system(size: 10, weight: .bold, design: .rounded))
            .foregroundStyle(Color(red: 0.10, green: 0.53, blue: 0.86))
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(Color(red: 0.10, green: 0.53, blue: 0.86).opacity(0.12))
            )
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

#Preview {
    NewsCard(item: NewsModel(
        title: "Weekend Offer",
        subtitle: "20% off skin fade appointments. Book now!",
        imageName: "barber-1",
        date: Date(),
        content: "Details about the weekend offer go here."
    ), isFeatured: true)
    .padding()
}
