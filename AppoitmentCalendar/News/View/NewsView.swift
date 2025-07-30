//
//  NewsView.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 29. 7. 2025..
//

import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel = NewsViewModel()

    var body: some View {
        VStack {
            navigation
            ScrollView {
                VStack {
                    
                    ScrollView {
                        title
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.news) { item in
                                NewsCard(news: item)
                            }
                        }
                        .padding()
                    }
                }
                .padding(.bottom, 130)
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}


#Preview {
    NewsView()
}

extension NewsView {
    var navigation: some View {
        HStack(spacing: 0) {
                Text("News")
                    .font(.title2.bold())
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .foregroundColor(.black)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.bottom)
    }
    
    var title: some View {
        VStack(alignment: .leading) {
            Text("All the latest updates, right here.")
                .font(.system(size: 28, weight: .semibold))
                .foregroundColor(.black)
                .padding(.vertical, 20)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 6)
        .padding(.horizontal)
    }
}
