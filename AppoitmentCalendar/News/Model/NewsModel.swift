//
//  NewsModel.swift
//  AppoitmentCalendar
//
//  Created by Djordje on 30. 7. 2025..
//

import Foundation
import FirebaseFirestore

struct NewsModel: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var body: String
}
