//
//  AppointmentView.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 30. 7. 2025..
//
import SwiftUI

struct AppointmentView: View {
    @State private var selectedTab: AppointmentTab = .upcoming

    var body: some View {
        
        ScrollView {
            VStack {
                picture
                picker
                appointments
                    .padding()
            }
        }
    .ignoresSafeArea()
        

        
    }

    @ViewBuilder
    private func appointmentCard(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    AppointmentView()
}


extension AppointmentView {
    private var picture : some View {
        Image("barber-logo")
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            .clipped()
            .cornerRadius(16)
            .padding(.horizontal)
            .padding(.top)
    }
    
    private var picker: some View {
        HStack(spacing: 0) {
            ForEach(AppointmentTab.allCases, id: \.self) { tab in
                Button(action: {
                    withAnimation(.spring) {
                        selectedTab = tab
                    }
                }) {
                    Text(tab.title)
                        .fontWeight(.semibold)
                        .foregroundColor(selectedTab == tab ? .white : .black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(selectedTab == tab ? Color.black : Color.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding(6)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private var appointments: some View {
        VStack(spacing: 16) {
            if selectedTab == .upcoming {
                ForEach(0..<1) { _ in
                    appointmentCard(title: "Upcoming Appointment", subtitle: "Monday, Aug 5 - 3:00 PM")
                }
            } else {
                ForEach(0..<5) { _ in
                    appointmentCard(title: "Past Appointment", subtitle: "Thursday, Jul 18 - 11:00 AM")
                }
            }
        }
    }
}
