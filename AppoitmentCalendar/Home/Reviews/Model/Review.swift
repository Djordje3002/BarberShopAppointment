import Foundation

struct Review: Identifiable {
    let id = UUID()
    let author: String
    let message: String
    let rating: Int
}
