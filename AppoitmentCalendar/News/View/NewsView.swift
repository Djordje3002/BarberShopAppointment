import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel = NewsViewModel()

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.92, green: 0.96, blue: 1.00),
                    Color(red: 0.98, green: 0.97, blue: 0.93)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 18) {
                    header

                    if let featuredItem {
                        NavigationLink {
                            NewsDetailView(item: featuredItem)
                        } label: {
                            NewsCard(item: featuredItem, isFeatured: true)
                                .foregroundStyle(.primary)
                        }
                        .buttonStyle(.plain)
                    }

                    LazyVStack(spacing: 14) {
                        ForEach(otherItems) { item in
                            NavigationLink {
                                NewsDetailView(item: item)
                            } label: {
                                NewsCard(item: item)
                                    .foregroundStyle(.primary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 100)
            }
            .scrollIndicators(.hidden)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("News & Updates")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.11, green: 0.16, blue: 0.24))

            Text("Promotions, shop announcements, and updates from the team.")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(Color(red: 0.33, green: 0.40, blue: 0.50))

            HStack(spacing: 8) {
                statPill(title: "Stories", value: "\(viewModel.items.count)")
                statPill(title: "Last Updated", value: Self.shortDateFormatter.string(from: Date()))
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white.opacity(0.88))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.85), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 14, x: 0, y: 6)
    }

    private func statPill(title: String, value: String) -> some View {
        HStack(spacing: 6) {
            Text(title)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundStyle(Color(red: 0.35, green: 0.42, blue: 0.52))

            Text(value)
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.10, green: 0.53, blue: 0.86))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.8))
        )
    }

    private var featuredItem: NewsModel? {
        viewModel.items.first
    }

    private var otherItems: [NewsModel] {
        Array(viewModel.items.dropFirst())
    }

    private static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

struct NewsDetailView: View {
    let item: NewsModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                hero

                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 8) {
                        Text(item.category.uppercased())
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(red: 0.10, green: 0.53, blue: 0.86))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 5)
                            .background(
                                Capsule()
                                    .fill(Color(red: 0.10, green: 0.53, blue: 0.86).opacity(0.12))
                            )

                        Text(Self.fullDateFormatter.string(from: item.date))
                            .font(.footnote.weight(.medium))
                            .foregroundStyle(.secondary)

                        Spacer()

                        Text("\(readTimeMinutes) min read")
                            .font(.footnote.weight(.medium))
                            .foregroundStyle(.secondary)
                    }

                    Text(item.title)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 0.11, green: 0.16, blue: 0.24))

                    Text(item.subtitle)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color(red: 0.29, green: 0.36, blue: 0.47))

                    Divider()

                    Text(item.content)
                        .font(.system(size: 17, weight: .regular, design: .serif))
                        .foregroundStyle(Color(red: 0.15, green: 0.20, blue: 0.28))
                        .lineSpacing(8)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 36)
                .background(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(Color.white.opacity(0.97))
                )
                .offset(y: -20)
                .padding(.bottom, -20)
            }
        }
        .background(Color(red: 0.95, green: 0.97, blue: 1.0))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.subheadline.weight(.semibold))
                }
            }
        }
    }

    @ViewBuilder
    private var hero: some View {
        if let imageName = item.imageName {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity)
                .frame(height: 260)
                .clipped()
                .overlay(
                    LinearGradient(
                        colors: [Color.black.opacity(0.08), Color.black.opacity(0.52)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        } else {
            LinearGradient(
                colors: [
                    Color(red: 0.90, green: 0.95, blue: 1.00),
                    Color(red: 1.00, green: 0.93, blue: 0.84)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 240)
            .frame(maxWidth: .infinity)
            .overlay(
                Image(systemName: "newspaper.fill")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(Color.white.opacity(0.9))
            )
        }
    }

    private var readTimeMinutes: Int {
        let wordCount = item.content.split { $0 == " " || $0.isNewline }.count
        return max(1, Int(ceil(Double(wordCount) / 180.0)))
    }

    private static let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}

#Preview {
    NavigationStack {
        NewsView()
    }
}
