import Foundation

struct HaircutOption: Identifiable, Hashable {
    let id = UUID()
    let description: String
    let imageName: String
    let haircutType: HaircutType

    var name: String {
        haircutType.rawValue
    }

    var price: Double {
        haircutType.price
    }
    
    init(type: HaircutType, description: String, imageName: String) {
        self.haircutType = type
        self.description = description
        self.imageName = imageName
    }
}
