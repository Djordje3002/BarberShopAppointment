//
//  NewsViewModel.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 30. 7. 2025..
//

import Foundation
import FirebaseFirestore

class NewsViewModel: ObservableObject {
    
    @Published var news: [NewsModel] = []
    private var db = Firestore.firestore()

    init() {
        fetchNews()
    }

    func fetchNews() {
        db.collection("news").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching news: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }

            self.news = documents.compactMap { doc in
                try? doc.data(as: NewsModel.self)
            }
            print("Fetched news count: \(self.news.count)")
        }
    }

}
