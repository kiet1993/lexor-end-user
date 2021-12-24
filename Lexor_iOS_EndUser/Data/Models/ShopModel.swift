//
//  HomeItem.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/06/04.
//

import Foundation

// MARK: - ShopModel
struct ShopModel: Decodable {
    let id: Int
    let name, address: String
    let lat, long: Double
    let workingHour: String
    let rating: Rating
    let myFavourite: Bool
    let images: [String]

    enum CodingKeys: String, CodingKey {
        case id, name, address, lat, long
        case workingHour = "working_hour"
        case rating
        case myFavourite = "my_favourite"
        case images
    }
}
