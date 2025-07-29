//
//  HomeView.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 29. 7. 2025..
//

import SwiftUI

struct HomeView: View {
    var body: some View {
            ScrollView {
                VStack {
                    picture
                        .frame(maxWidth: .infinity)
                        .ignoresSafeArea(edges: .top)
                    
                    CustomButton(title: "Book appointment") {
                        print("Book appointment tapped")
                    }
                    .offset(y: -100)
                    
                    aboutUs
                        .offset(y: -30)
                    
                    reviews
                    
                }
            }
        .ignoresSafeArea()
    }
}

#Preview {
    HomeView()
}

extension HomeView {
    private var picture: some View {
            Image("barbershop")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.3))
                .overlay(
                    ZStack {
                        LinearGradient(gradient: Gradient(colors: [.black.opacity(0.6), .clear]), startPoint: .top, endPoint: .bottom)
                    }
                )
                .clipped()
        }
    
    private var aboutUs: some View {
            VStack(spacing: 30) {
                Text("About Us")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text("We are a modern barbershop dedicated to providing top-notch grooming services with a friendly vibe. Our team of skilled barbers ensures you leave looking and feeling your best.")
                    .font(.body)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                
                HStack(spacing: 10) {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.black)
                        .font(.title2)
                    Text("Phone: (555) 123-4567")
                        .font(.body)
                        .foregroundColor(.black)
                }
                .onTapGesture {
                    if let url = URL(string: "tel://5551234567") {
                        UIApplication.shared.open(url)
                    }
                }
                
                VStack(spacing: 20) {
                    Button(action: {
                        if let url = URL(string: "https://www.instagram.com/yourbarbershop") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        VStack(spacing: 20) {
                            Image(systemName: "camera.fill")
                                .foregroundColor(.black)
                                .font(.title2)
                            Text("Instagram")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .frame(width: 150)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 5)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 0))
                    }
                    
                    Button(action: {
                        if let url = URL(string: "https://www.tiktok.com/@yourbarbershop") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        VStack(spacing: 20) {
                            Image(systemName: "video.fill")
                                .foregroundColor(.black)
                                .font(.title2)
                            Text("TikTok")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .frame(width: 150)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 5)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 0))
                    }
                }
            }
        }
    
    private var reviews: some View {
            VStack(spacing: 30) {
                Text("Reviews")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("What others tell about us")
                    .font(.body)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                HStack(spacing: 10) {
                    ForEach(1..<6) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.title2)
                    }
                }
                NavigationLink {
                    ReviewsView()
                } label: {
                    Text("See Reviews")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 300)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 5)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 0))
                }

            }
            .padding(.bottom, 42)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.black)
        }

}
