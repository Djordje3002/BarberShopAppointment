//
//  SettingsView.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 29. 7. 2025..
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        userInfo
    }
}

#Preview {
    ProfileView()
}


extension ProfileView {
        private var userInfo: some View {
            VStack {
                Image("pearson-image")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 128, height: 128)
                    .clipShape(RoundedRectangle(cornerRadius: 64))
    
                Text("User Profile")
                    .font(.largeTitle)
                    .bold()
            }
        }
}
