//
//  TechnicianListCellModel.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 7/11/21.
//

import Foundation

final class TechnicianListCellModel {

    // MARK: - Properties
    let technicianData: TechnicianModel?
    let indexPath: IndexPath
    let isNoService: Bool

    // MARK: - Init
    init(technicianData: TechnicianModel?, indexPath: IndexPath, isNoService: Bool) {
        self.technicianData = technicianData
        self.indexPath = indexPath
        self.isNoService = isNoService
    }
}
