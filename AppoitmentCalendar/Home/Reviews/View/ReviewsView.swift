//
//  ReviewsView().swift
//  AppoitmentCalendar
//
//  Created by Djordje on 29. 7. 2025..

import SwiftUI

struct ReviewsView: View {
    @StateObject private var viewModel = ReviewsViewModel()

    var body: some View {
        VStack(spacing: 0) {
            navigation
            
            if viewModel.isLoading {
                ProgressView()
                    .padding(.top)
                Spacer()
            } else if viewModel.reviews.isEmpty {
                Text("No reviews yet.")
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.reviews) { review in
                            ReviewCard(review: review)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(edges: .bottom)
    }
}


    #Preview {
        ReviewsView()
    }

extension ReviewsView {
    var navigation: some View {
        Text("Reviews")
            .font(.title2.bold())
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .foregroundColor(.black)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)

    }
}
