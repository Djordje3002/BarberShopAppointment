import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel = NewsViewModel()

    var body: some View {
        VStack(spacing: 0) {
            // Custom Header
            HStack {
                Text("News & Updates")
                    .font(.title.bold())
                Spacer()
            }
            .padding()
            .background(Color(UIColor.systemBackground))

            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.items) { item in
                        NavigationLink {
                            NewsDetailView(item: item)
                        } label: {
                            NewsCard(item: item)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}

struct NewsDetailView: View {
    let item: NewsModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageName = item.imageName {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .frame(height: 250)
                        .clipped()
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text(item.date, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(item.title)
                        .font(.title)
                        .fontWeight(.bold)

                    Divider()

                    Text(item.subtitle)
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Text(item.content)
                        .font(.body)
                        .lineSpacing(6)
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        NewsView()
    }
}
