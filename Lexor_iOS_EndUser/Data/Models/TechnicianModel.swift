//
//  TechnicianModel.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 7/10/21.
//

import Foundation

struct TechnicianModel {
    var avatarURL: String
    var name: String
    var services: [Service] = []
    var isFavorite: Bool
}
