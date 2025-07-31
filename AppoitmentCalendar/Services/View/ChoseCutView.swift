//
//  ChoseCutView.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 31. 7. 2025..
//

import SwiftUI

struct ChoseCutView: View {
    @ObservedObject var viewModel = ChoseCutViewModel()
    
    let options: [HaircutOption] = [
        .init(name: "Classic Haircut", description: "Timeless clean look.", imageName: "cut-classic"),
        .init(name: "Classic + Beard", description: "Classic style & neat beard.", imageName: "cut-classic-beard"),
        .init(name: "Modern Haircut", description: "Trendy fresh cut.", imageName: "cut-modern"),
        .init(name: "Modern + Beard", description: "Modern style with full beard grooming.", imageName: "cut-modern-beard"),
        .init(name: "Full Grooming", description: "Haircut + Beard + Details.", imageName: "cut-full"),
        .init(name: "Shave Beard", description: "Complete beard removal.", imageName: "cut-shave-beard"),
        .init(name: "Shave Head", description: "Full head shave.", imageName: "cut-shave-head"),
        .init(name: "Kids under 5", description: "Quick cut for little champs.", imageName: "cut-kids"),
        .init(name: "Beard Shaping", description: "Outline & define beard.", imageName: "cut-beard-shape")
    ]
    
    var body: some View {
        VStack {
            CustomNavBar(title: "Chose service")
            Spacer()
            ScrollView {
                ScrollView {
                    Text("Choose Your Cut")
                        .font(.title.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    ForEach(options) { option in
                        HaircutCard(option: option, isSelected: option.id == viewModel.selectedCut?.id) {
                            viewModel.selectedCut = option
                        }
                    }
                }
                .ignoresSafeArea()
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}


#Preview {
    ChoseCutView()
}

