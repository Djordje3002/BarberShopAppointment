//
//  ReviewsViewModel.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 31. 7. 2025..
//

import Foundation
import FirebaseFirestore

class ReviewsViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    @Published var isLoading = true

    private let db = Firestore.firestore()

    init() {
        fetchReviews()
    }

    func fetchReviews() {
        db.collection("reviews")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                DispatchQueue.main.async {
                    self.isLoading = false
                }

                if let error = error {
                    print("❌ Error fetching reviews: \(error.localizedDescription)")
                    return
                }

                if let documents = snapshot?.documents {
                    self.reviews = documents.compactMap { try? $0.data(as: Review.self) }
                }
            }
    }
}

