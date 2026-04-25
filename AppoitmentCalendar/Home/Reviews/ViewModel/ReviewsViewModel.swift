import Foundation

@MainActor
final class ReviewsViewModel: ObservableObject {
    @Published var reviews: [Review] = []

    // TODO: Connect to Firestore `reviews` collection when ready.
    // Currently serving static mock data for UI demonstration.
    func load() {
        reviews = [
            Review(author: "Ana", message: "Fast service and great atmosphere.", rating: 5),
            Review(author: "Luka", message: "Clean cut and fair price.", rating: 4),
            Review(author: "Mina", message: "Loved the booking flow and punctuality.", rating: 5)
        ]
    }
}
