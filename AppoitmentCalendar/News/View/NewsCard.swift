import SwiftUI

struct NewsCard: View {
    let item: NewsModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let imageName = item.imageName {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 180)
                    .clipped()
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(item.date, style: .date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                }

                Text(item.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)

                Text(item.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
            }
            .padding()
        }
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    NewsCard(item: NewsModel(
        title: "Weekend Offer",
        subtitle: "20% off skin fade appointments. Book now!",
        imageName: "barber-1",
        date: Date(),
        content: "Details about the weekend offer go here."
    ))
    .padding()
}
