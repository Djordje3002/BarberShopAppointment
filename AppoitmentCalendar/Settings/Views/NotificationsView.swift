//
//  NotificationsView.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 30. 7. 2025..
//

import SwiftUI

struct NotificationsView: View {
    var body: some View {
        VStack {
            CustomNavBar(title: "Notifications")
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NotificationsView()
}
