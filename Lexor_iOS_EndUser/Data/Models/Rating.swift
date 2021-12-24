//
//  Rating.swift
//  Lexor_iOS_EndUser
//
//  Created by Harosc on 10/23/21.
//

import Foundation

struct Rating: Codable {
    let voteID: Int
    let ratingID: Int
    let percent: Double
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case voteID = "vote_id"
        case ratingID = "rating_id"
        case percent, value
    }
}
