//
//  BookAppointTechCellModel.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 6/8/21.
//

import Foundation

final class BookAppointTechCellModel {

    // MARK: - Properties
    let name: String
    let imageURL: String
    let isSelected: Bool

    // MARK: - Init
    init(technician: TechnicianModel, isFavorite: Bool) {
        self.name = technician.name
        self.imageURL = technician.avatarURL
        self.isSelected = isFavorite
    }
}
