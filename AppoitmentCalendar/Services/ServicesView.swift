//
//  ServicesView.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 29. 7. 2025..
//

import SwiftUI

struct ServicesView: View {
    @EnvironmentObject var router: NavigationRouter

    var body: some View {
        ScrollView {
            VStack {
                picture
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea(edges: .top)

                VStack(alignment: .leading) {
                    Text("Choose barber for your next cut")
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

                VStack {
                    CustomEmploye(name: "Michael", description: "CEO and barber", image: "barber-1") {
                        router.push(.choseDate)
                    }
                    CustomEmploye(name: "John", description: "Barber", image: "barber-2") {
                        router.push(.choseDate)
                    }
                    CustomEmploye(name: "Mirko", description: "Young Barber", image: "barber-0") {
                        router.push(.choseDate)
                    }
                    CustomEmploye(name: "Vukasin", description: "Mater Barber", image: "barber-3") {
                        router.push(.choseDate)
                    }
                }
                .padding()
                .padding(.bottom, 130)
            }
        }
        .ignoresSafeArea()
    }
}


extension ServicesView {
    private var picture: some View {
            Image("barber-0")
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
}

#Preview {
    ServicesView()
        .environmentObject(NavigationRouter())
}
