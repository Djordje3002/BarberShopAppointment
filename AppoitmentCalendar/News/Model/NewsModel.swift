import Foundation

struct NewsModel: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageName: String?
    let date: Date
    let content: String
}
