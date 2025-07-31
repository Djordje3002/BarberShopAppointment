//
//  ReviewCard.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 31. 7. 2025..
//

import SwiftUI

struct ReviewCard: View {
    let review: Review

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(review.name)
                    .font(.headline)
                Spacer()
            }

            Text(review.comment)
                .font(.body)
                .foregroundColor(.black)

            Text(review.timestamp, style: .date)
                .font(.caption)
                .foregroundColor(.gray)
            
            HStack(spacing: 2) {
                ForEach(0..<5, id: \.self) { index in
                    Image(systemName: index < review.rating ? "star.fill" : "star.fill")
                        .foregroundColor(index < review.rating ? .yellow : .gray.opacity(0.4))
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
    }
}

#Preview {
    ReviewCard(review: Review(id: "1", name: "Alice", comment: "Great experience!", rating: 5, timestamp: Date()))
        .padding()
}


