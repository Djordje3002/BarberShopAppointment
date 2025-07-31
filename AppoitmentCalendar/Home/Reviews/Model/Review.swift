//
//  Review.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 31. 7. 2025..
//

import Foundation
import FirebaseFirestore

struct Review: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var comment: String
    var rating: Int
    var timestamp: Date
}
