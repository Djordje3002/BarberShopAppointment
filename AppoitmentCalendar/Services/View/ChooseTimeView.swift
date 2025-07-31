//
//  ChooseTimeView.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 31. 7. 2025..
//


import SwiftUI

// MARK: - Time Selection Screen

struct ChooseTimeView: View {
    let date: Date
    @State private var selectedTime: String? = nil
    @EnvironmentObject var router: NavigationRouter

    let times = [
        "09:00 AM", "10:00 AM", "11:00 AM", "12:00 PM",
        "01:00 PM", "02:00 PM", "03:00 PM", "04:00 PM"
    ]

    var body: some View {
        VStack {
            CustomNavBar(title: "Chose time")
            
            VStack(alignment: .leading, spacing: 20) {
                
                Text("Select a time for")
                    .font(.headline)
                
                Text(formattedDate(date))
                    .font(.title2)
                    .bold()
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                    ForEach(times, id: \.self) { time in
                        Button {
                            selectedTime = time
                        } label: {
                            Text(time)
                                .frame(maxWidth: .infinity)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(selectedTime == time ? Color.blue : Color.gray.opacity(0.2))
                                )
                                .foregroundColor(selectedTime == time ? .white : .primary)
                        }
                    }
                }
                
                VStack(alignment: .center) {
                    if let selectedTime = selectedTime {
                        CustomButton(title: "Confirm") {
                            router.push(.cofirmAppointment)
                            
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Pick Time")
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}

#Preview {
    ChooseTimeView(date: Date.now)
}
