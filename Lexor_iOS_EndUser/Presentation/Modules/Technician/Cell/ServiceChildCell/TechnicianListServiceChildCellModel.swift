//
//  TechnicianListServiceChildCellModel.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 7/11/21.
//

import Foundation

final class TechnicianListServiceChildCellModel {
    // MARK: - Properties
    let serviceCellData: TechnicianListVM.ServiceCellData?
    let indexPath: IndexPath

    // MARK: - Init
    init(serviceCellData: TechnicianListVM.ServiceCellData?, indexPath: IndexPath) {
        self.serviceCellData = serviceCellData
        self.indexPath = indexPath
    }
}
