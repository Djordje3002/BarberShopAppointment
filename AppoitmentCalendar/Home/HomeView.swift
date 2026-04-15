//
//  HomeView.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 29. 7. 2025..
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                bookingSection
                
                aboutUsSection
                
                socialMediaSection
                
                reviewsSection
                
                mapSection
            }
            .padding(.bottom, 100)
        }
        .ignoresSafeArea(edges: .top)
        .background(Color(UIColor.systemBackground))
    }
}

extension HomeView {
    private var headerSection: some View {
        ZStack(alignment: .bottomLeading) {
            Image("barbershop")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity)
                .frame(height: 350)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .clipped()
            
            VStack(alignment: .leading, spacing: 8) {
                Image("barber-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                
                Text("THE BARBER SHOP")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                Text("Premium Grooming & Style")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(24)
        }
    }
    
    private var bookingSection: some View {
        VStack(spacing: 16) {
            CustomButton(title: "Book Appointment Now") {
                router.push(.chooseBarber)
            }
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        }
        .padding(.horizontal)
        .offset(y: -20)
    }
    
    private var aboutUsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("About Us")
                .font(.title2.bold())
                .foregroundColor(.primary)
            
            Text("We are a modern barbershop dedicated to providing top-notch grooming services with a friendly vibe. Our team of skilled barbers ensures you leave looking and feeling your best.")
                .font(.body)
                .foregroundColor(.secondary)
                .lineSpacing(4)
            
            HStack(spacing: 12) {
                Image(systemName: "phone.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.primary)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text("Call Us")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("(555) 123-4567")
                        .font(.body.bold())
                }
            }
            .onTapGesture {
                if let url = URL(string: "tel://5551234567") {
                    UIApplication.shared.open(url)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(UIColor.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding(.horizontal)
    }
    
    private var socialMediaSection: some View {
        HStack(spacing: 16) {
            socialButton(title: "Instagram", icon: "camera.fill", url: "https://www.instagram.com/yourbarbershop")
            socialButton(title: "TikTok", icon: "video.fill", url: "https://www.tiktok.com/@yourbarbershop")
        }
        .padding(.horizontal)
    }
    
    private func socialButton(title: String, icon: String, url: String) -> some View {
        Button(action: {
            if let url = URL(string: url) {
                UIApplication.shared.open(url)
            }
        }) {
            HStack {
                Image(systemName: icon)
                Text(title)
                    .fontWeight(.semibold)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.secondarySystemBackground))
            .foregroundColor(.primary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var reviewsSection: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text("Client Reviews")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                Text("What our customers say")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            HStack(spacing: 4) {
                ForEach(0..<5) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.title3)
                }
                Text("5.0")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.leading, 4)
            }
            
            NavigationLink {
                ReviewsView()
            } label: {
                Text("See All Reviews")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.black)
        )
        .padding(.horizontal)
    }
    
    private var mapSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Our Location")
                .font(.title2.bold())
                .padding(.horizontal)
            
            MapView()
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(NavigationRouter())
}
