import Foundation

enum HaircutType: String, Codable, CaseIterable, Identifiable {
    case classic = "Classic Haircut"
    case classicBeard = "Classic + Beard"
    case modern = "Modern Haircut"
    case modernBeard = "Modern + Beard"
    case fullGrooming = "Full Grooming"
    case beardShaping = "Beard Shaping"
    case shaveHead = "Shave Head"
    case shaveBeard = "Shave Beard"
    case kids = "Kids under 5"

    var id: String { rawValue }

    var price: Double {
        switch self {
        case .classic: return 10
        case .classicBeard: return 15
        case .modern: return 12
        case .modernBeard: return 17
        case .fullGrooming: return 20
        case .beardShaping: return 8
        case .shaveHead: return 9
        case .shaveBeard: return 7
        case .kids: return 6
        }
    }
}
