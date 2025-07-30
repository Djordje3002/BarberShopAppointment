//
//  CustomEmploye.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 30. 7. 2025..
//

import SwiftUI

struct CustomEmploye: View {
    let name: String
    let description: String
    let image: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 22) {
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray.opacity(0.2), lineWidth: 2))
                    .shadow(radius: 5)


                VStack(alignment: .leading, spacing: 6) {
                    Text(name)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
        }
        .padding(.horizontal, 4)
    }
}


#Preview {
    CustomEmploye(name: "Michael", description: "Best barber", image: "barber-1") {
        
    }
}
