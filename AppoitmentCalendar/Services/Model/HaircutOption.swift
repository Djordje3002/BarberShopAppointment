import Foundation

struct HaircutOption: Identifiable, Hashable, Codable {
    let type: HaircutType
    let description: String
    let imageName: String

    var id: String { type.rawValue }
    var name: String { type.displayName }
    var price: Double { type.price }
}
