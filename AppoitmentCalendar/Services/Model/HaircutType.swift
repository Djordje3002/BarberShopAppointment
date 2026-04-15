import Foundation

enum HaircutType: String, CaseIterable, Codable {
    case classic
    case fade
    case beardTrim
    case kidsCut

    var displayName: String {
        switch self {
        case .classic:
            return "Classic Cut"
        case .fade:
            return "Skin Fade"
        case .beardTrim:
            return "Beard Trim"
        case .kidsCut:
            return "Kids Cut"
        }
    }

    var price: Double {
        switch self {
        case .classic:
            return 15
        case .fade:
            return 20
        case .beardTrim:
            return 12
        case .kidsCut:
            return 13
        }
    }
}
