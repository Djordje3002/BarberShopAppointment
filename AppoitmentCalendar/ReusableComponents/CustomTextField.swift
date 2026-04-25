import SwiftUI

struct CustomTextField: View {
    let iconName: String
    let placeholder: String
    var isSecure: Bool = false
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.gray)
                .frame(width: 20)
            
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

struct PhoneNumberField: View {
    @Binding var phoneNumber: String

    @State private var selectedCountry: PhoneInputCountry
    @State private var localNumber: String

    init(phoneNumber: Binding<String>) {
        _phoneNumber = phoneNumber

        let parsed = PhoneInputCountry.parse(phoneNumber.wrappedValue)
        _selectedCountry = State(initialValue: parsed.country)
        _localNumber = State(initialValue: PhoneInputCountry.format(digits: parsed.localDigits, for: parsed.country))
    }

    var body: some View {
        HStack(spacing: 10) {
            Menu {
                ForEach(PhoneInputCountry.all) { country in
                    Button {
                        selectedCountry = country
                        updateLocalNumber(localNumber)
                    } label: {
                        Text("\(country.code) \(country.dialCode)")
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Text(selectedCountry.code)
                    Text(selectedCountry.dialCode)
                    Image(systemName: "chevron.down")
                        .font(.caption)
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(Color(.systemBackground))
                )
            }
            .buttonStyle(.plain)

            Divider()
                .frame(height: 24)

            TextField(selectedCountry.placeholder, text: Binding(
                get: { localNumber },
                set: { updateLocalNumber($0) }
            ))
            .keyboardType(.numberPad)
            .textContentType(.telephoneNumber)
            .autocorrectionDisabled(true)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal)
    }

    private func updateLocalNumber(_ value: String) {
        let digits = String(value.filter(\.isNumber).prefix(selectedCountry.maxDigits))
        localNumber = PhoneInputCountry.format(digits: digits, for: selectedCountry)
        phoneNumber = digits.isEmpty ? "" : "\(selectedCountry.dialCode)\(digits)"
    }
}

private struct PhoneInputCountry: Identifiable, Equatable {
    let code: String
    let dialCode: String
    let maxDigits: Int
    let placeholder: String

    var id: String { code }

    static let all: [PhoneInputCountry] = [
        .init(code: "US", dialCode: "+1", maxDigits: 10, placeholder: "(555) 123-4567"),
        .init(code: "UK", dialCode: "+44", maxDigits: 10, placeholder: "7400 123 456"),
        .init(code: "DE", dialCode: "+49", maxDigits: 11, placeholder: "1512 3456789"),
        .init(code: "RS", dialCode: "+381", maxDigits: 9, placeholder: "60 123 4567"),
        .init(code: "AU", dialCode: "+61", maxDigits: 9, placeholder: "412 345 678")
    ]

    static func parse(_ input: String) -> (country: PhoneInputCountry, localDigits: String) {
        let digitsOnly = input.filter { $0.isNumber || $0 == "+" }
        let countriesByDialLength = all.sorted { $0.dialCode.count > $1.dialCode.count }

        for country in countriesByDialLength where digitsOnly.hasPrefix(country.dialCode) {
            let rawLocal = String(digitsOnly.dropFirst(country.dialCode.count))
            let localDigits = String(rawLocal.filter(\.isNumber).prefix(country.maxDigits))
            return (country, localDigits)
        }

        let fallback = all[0]
        let localDigits = String(digitsOnly.filter(\.isNumber).prefix(fallback.maxDigits))
        return (fallback, localDigits)
    }

    static func format(digits: String, for country: PhoneInputCountry) -> String {
        if country.code == "US" {
            let limited = String(digits.prefix(country.maxDigits))
            switch limited.count {
            case 0:
                return ""
            case 1...3:
                return "(\(limited)"
            case 4...6:
                let area = limited.prefix(3)
                let prefix = limited.dropFirst(3)
                return "(\(area)) \(prefix)"
            default:
                let area = limited.prefix(3)
                let prefix = limited.dropFirst(3).prefix(3)
                let line = limited.dropFirst(6)
                return "(\(area)) \(prefix)-\(line)"
            }
        }

        var parts: [String] = []
        var index = digits.startIndex
        while index < digits.endIndex {
            let nextIndex = digits.index(index, offsetBy: 3, limitedBy: digits.endIndex) ?? digits.endIndex
            parts.append(String(digits[index..<nextIndex]))
            index = nextIndex
        }
        return parts.joined(separator: " ")
    }
}

#Preview {
    VStack {
        CustomTextField(iconName: "envelope", placeholder: "Email", text: .constant(""))
        CustomTextField(iconName: "lock", placeholder: "Password", isSecure: true, text: .constant(""))
        PhoneNumberField(phoneNumber: .constant("+15551234567"))
    }
}
