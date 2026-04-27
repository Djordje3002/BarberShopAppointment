import Foundation

struct NewsModel: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageName: String?
    let date: Date
    let content: String

    var category: String {
        let text = title.lowercased()
        if text.contains("opening") || text.contains("station") {
            return "Shop"
        }
        if text.contains("weekend") || text.contains("special") || text.contains("offer") {
            return "Promo"
        }
        if text.contains("product") {
            return "Products"
        }
        if text.contains("team") || text.contains("member") {
            return "Team"
        }
        if text.contains("holiday") || text.contains("hours") {
            return "Schedule"
        }
        return "Update"
    }
}
