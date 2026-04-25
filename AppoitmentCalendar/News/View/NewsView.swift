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
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageName = item.imageName {
                    ZStack(alignment: .topLeading) {
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity)
                            .frame(height: 350)
                            .clipped()
                        
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title3.bold())
                                .foregroundColor(.primary)
                                .padding(12)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                        .padding(.top, 60)
                        .padding(.leading, 20)
                    }
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
                .padding(.bottom, 40)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        NewsView()
    }
}
