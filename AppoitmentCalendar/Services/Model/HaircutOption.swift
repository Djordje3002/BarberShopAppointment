import Foundation

struct HaircutOption: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let imageName: String

    var price: Double {
        switch name {
        case "Classic Haircut": return 15
        case "Classic + Beard": return 20
        case "Modern Haircut": return 18
        case "Modern + Beard": return 23
        case "Full Grooming": return 28
        case "Shave Beard": return 10
        case "Shave Head": return 12
        case "Kids under 5": return 8
        case "Beard Shaping": return 14
        default: return 0
        }
    }
}
