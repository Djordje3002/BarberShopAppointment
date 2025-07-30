//
//  NewsCard.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 30. 7. 2025..
//

import SwiftUI

struct NewsCard: View {
    let news: NewsModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(news.title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(news.body)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}


