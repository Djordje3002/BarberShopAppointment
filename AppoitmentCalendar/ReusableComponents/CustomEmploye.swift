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
            HStack(spacing: 12) {
                Image(image)
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundColor(.black)

                VStack {
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
   CustomEmploye(name: <#T##String#>, description: <#T##String#>, image: <#T##String#>, action: <#T##() -> Void#>)
}
