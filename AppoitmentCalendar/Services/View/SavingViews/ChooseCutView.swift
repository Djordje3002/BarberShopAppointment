import SwiftUI

struct ChooseCutView: View {
    @EnvironmentObject var appointment: AppointmentBooking
    @EnvironmentObject var router: NavigationRouter

    let options: [HaircutOption] = [
        .init(type: .classic, description: "Timeless clean look.", imageName: "barber-0"),
        .init(type: .classicBeard, description: "Classic style & neat beard.", imageName: "barber-1"),
        .init(type: .modern, description: "Trendy fresh cut.", imageName: "barber-3"),
        .init(type: .modernBeard, description: "Modern style with full beard grooming.", imageName: "barber-2"),
        .init(type: .fullGrooming, description: "Haircut + Beard + Details.", imageName: "barber-0"),
        .init(type: .shaveBeard, description: "Complete beard removal.", imageName: "barber-1"),
        .init(type: .shaveHead, description: "Full head shave.", imageName: "barber-1"),
        .init(type: .kids, description: "Quick cut for little champs.", imageName: "barber-2"),
        .init(type: .beardShaping, description: "Outline & define beard.", imageName: "barber-3")
    ]

    var body: some View {
        VStack {
            CustomNavBar(title: "Choose Service")

            ScrollView {
                ForEach(options) { option in
                    let isSelected = appointment.selectedCut?.id == option.id
                    
                    HaircutCard(option: option, isSelected: isSelected) {
                        appointment.selectedCut = option
                        router.push(.chooseDate)
                    }
                }
            }
        }
    }
}

#Preview {
    ChooseCutView()
        .environmentObject(AppointmentBooking())
        .environmentObject(NavigationRouter())
}
