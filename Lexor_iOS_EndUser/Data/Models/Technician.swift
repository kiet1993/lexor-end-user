//
//  Technician.swift
//  Lexor_iOS_EndUser
//
//  Created by Harosc on 10/23/21.
//

import Foundation

struct Technician: Codable {
    let id: Int
    let name: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case imageURL = "media_path"
    }
}
