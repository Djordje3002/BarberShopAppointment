//
//  WaitListView.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 30. 7. 2025..
//

import SwiftUI

struct WaitListView: View {
    @EnvironmentObject var appointment: AppointmentBooking
    @EnvironmentObject var contentVM: ContentViewModel
    @State private var myAppointments: [Appointment] = []
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            CustomNavBar(title: "My Appointments")
            
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if myAppointments.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No appointments booked yet.")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(myAppointments) { appt in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(appt.cutName)
                                .font(.headline)
                            Spacer()
                            Text(String(format: "%.2f €", appt.price))
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                        
                        Text("Barber: \(appt.barberName)")
                            .font(.subheadline)
                        
                        HStack {
                            Image(systemName: "calendar")
                            Text("\(formattedDate(appt.date)) at \(appt.time)")
                        }
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        
                        Text("Booked by: \(appt.username)")
                            .font(.caption)
                            .foregroundColor(.blue)
                            .padding(.top, 2)
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationBarBackButtonHidden()
        .task {
            guard let email = contentVM.currentUser?.email else { return }
            isLoading = true
            do {
                myAppointments = try await appointment.fetchUserAppointments(email: email)
            } catch {
                print("Failed to fetch appointments: \(error)")
            }
            isLoading = false
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    WaitListView()
}
