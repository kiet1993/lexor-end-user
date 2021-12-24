//
//  AdModel.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/07/15.
//

import Foundation

// MARK: - Ad
struct AdModel: Codable {
    let id: Int
    let title: String?
    let description: String
    let image: String
    let name: String?
}
