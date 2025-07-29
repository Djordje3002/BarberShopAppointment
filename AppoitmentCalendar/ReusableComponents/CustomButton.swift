import SwiftUI

struct CustomButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
                .padding()
                .frame(width: 300)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 5)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 0))
        }
    }
}

#Preview {
    CustomButton(title: "Book appointment") {
        
    }
}
