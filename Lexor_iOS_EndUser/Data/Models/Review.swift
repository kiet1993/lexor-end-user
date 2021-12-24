//
//  Review.swift
//  Lexor_iOS_EndUser
//
//  Created by Harosc on 10/23/21.
//

import Foundation

struct Review: Codable {
    let id: Int
    let title: String?
    let detail: String?
    let nickname: String?
    let ratings: [Rating]
    let createdDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, title, detail, nickname, ratings
        case createdDate = "created_at"
    }
}
