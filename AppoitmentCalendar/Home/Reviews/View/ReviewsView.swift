import SwiftUI

struct ReviewsView: View {
    @StateObject private var viewModel = ReviewsViewModel()

    var body: some View {
        List(viewModel.reviews) { review in
            ReviewCard(review: review)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .navigationTitle("Reviews")
        .onAppear {
            viewModel.load()
        }
    }
}

#Preview {
    NavigationStack {
        ReviewsView()
    }
}
