//
//  HomeView.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 29. 7. 2025..
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Image("barbershop")
                .resizable()
                .scaledToFill()
                .frame(width: 400, height: 400)
            
            Spacer()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    HomeView()
}
