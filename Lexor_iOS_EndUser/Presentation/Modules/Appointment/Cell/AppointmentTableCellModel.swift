//
//  AppointmentTableCellModel.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 7/4/21.
//

import Foundation

final class AppointmentTableCellModel {

    // MARK: - Properties
    let appointmentData: AppointmentParentVM.AppointmentData
    let indexPath: IndexPath
    let screenType: AppointmentParentVC.MenuType

    // MARK: - Init
    init(appointmentData: AppointmentParentVM.AppointmentData, indexPath: IndexPath, screenType: AppointmentParentVC.MenuType) {
        self.appointmentData = appointmentData
        self.indexPath = indexPath
        self.screenType = screenType
    }
}
