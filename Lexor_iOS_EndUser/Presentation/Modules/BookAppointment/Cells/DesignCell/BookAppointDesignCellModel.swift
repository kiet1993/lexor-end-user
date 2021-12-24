//
//  BookAppointDesignCellModel.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 6/8/21.
//

import Foundation

final class BookAppointDesignCellModel {

    // MARK: - Properties
    let name: String
    let colorHex: String
    let isSelected: Bool

    // MARK: - Init
    init(design: Designer, isSelected: Bool) {
        self.name = design.name
        self.colorHex = design.hexColorStr
        self.isSelected = isSelected
    }
}
