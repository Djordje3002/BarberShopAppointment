import SwiftUI

struct IGTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .padding(.horizontal)
            .foregroundStyle(.primary)
    }
}

extension View {
    func igTextFieldStyle() -> some View {
        self.modifier(IGTextFieldModifier())
    }
}
