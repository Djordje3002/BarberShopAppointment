import SwiftUI

struct ChoseCutView: View {
    @EnvironmentObject var appointment: AppointmentBooking
    @EnvironmentObject var router: NavigationRouter

    let options: [HaircutOption] = [
        .init(name: "Classic Haircut", description: "Timeless clean look.", imageName: "barber-0"),
        .init(name: "Classic + Beard", description: "Classic style & neat beard.", imageName: "barber-1"),
        .init(name: "Modern Haircut", description: "Trendy fresh cut.", imageName: "barber-3"),
        .init(name: "Modern + Beard", description: "Modern style with full beard grooming.", imageName: "barber-2"),
        .init(name: "Full Grooming", description: "Haircut + Beard + Details.", imageName: "barber-0"),
        .init(name: "Shave Beard", description: "Complete beard removal.", imageName: "barber-1"),
        .init(name: "Shave Head", description: "Full head shave.", imageName: "barber-1"),
        .init(name: "Kids under 5", description: "Quick cut for little champs.", imageName: "barber-2"),
        .init(name: "Beard Shaping", description: "Outline & define beard.", imageName: "barber-3")
    ]

    var body: some View {
        VStack {
            CustomNavBar(title: "Choose Service")

            ScrollView {
                ForEach(options) { option in
                    let isSelected = appointment.selectedCut?.id == option.id
                    
                    HaircutCard(option: option, isSelected: isSelected) {
                        appointment.selectedCut = option
                        router.push(.choseDate)
                    }
                }
            }
        }
    }
}

#Preview {
    ChoseCutView()
        .environmentObject(AppointmentBooking())
        .environmentObject(NavigationRouter())
}
