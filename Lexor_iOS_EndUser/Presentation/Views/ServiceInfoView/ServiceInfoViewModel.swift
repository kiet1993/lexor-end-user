//
//  ServiceInfoViewModel.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 6/7/21.
//

import Foundation

final class ServiceInfoViewModel {
    // MARK: - Properties
    let serviceInfo: Service
    let isShowWaitButton: Bool
    let isCanDelete: Bool

    // MARK: - Init
    init(serviceInfo: Service, isShowWaitButton: Bool, isCanDelete: Bool) {
        self.serviceInfo = serviceInfo
        self.isShowWaitButton = isShowWaitButton
        self.isCanDelete = isCanDelete
    }
}
