//
//  CustomNavBar.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 30. 7. 2025..
//

import SwiftUI

struct CustomNavBar: View {
    @Environment(\.dismiss) var dismiss
    var title: String
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text(title)
                    .font(.title2.bold())

                HStack {
                    Image(systemName: "chevron.left")
                        .onTapGesture {
                            dismiss()
                        }
                    
                    Spacer()
                }
            }
            .padding()
            .padding(.bottom, 8)
            .frame(maxWidth: .infinity)
            .background(
                Color.white
                    .ignoresSafeArea(edges: .top)
            )
            .foregroundColor(.black)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 6)
        }
    }

}

#Preview {
    CustomNavBar(title: "Navigation")
}

