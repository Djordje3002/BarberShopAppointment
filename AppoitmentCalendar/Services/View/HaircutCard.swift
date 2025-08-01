//
//  HaircutCard.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 31. 7. 2025..
//

import SwiftUI

struct HaircutCard: View {
    let option: HaircutOption
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(option.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipped()
                    .cornerRadius(12)
                
                VStack(alignment: .leading) {
                    Text(option.name)
                        .font(.headline)
                    Text(option.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                
                Image(systemName: "chevron.right")
                    .padding()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
    }
}

#Preview {
    HaircutCard(
        option: HaircutOption(
            name: "Classic Haircut",
            description: "Timeless clean look.",
            imageName: "cut-classic"
        ),
        isSelected: true,
        action: {}
    )
}

