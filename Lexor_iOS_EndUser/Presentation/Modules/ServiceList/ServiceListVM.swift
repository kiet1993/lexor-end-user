//
//  ServiceListVM.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 6/8/21.
//

import Foundation

final class ServiceListVM {
    // MARK: - Properties
    let services: [Service]

    // MARK: - Init
    init(serviceList: [Service]) {
        services = serviceList
    }

    // MARK: - Public
    func viewModelForServicesView() -> ServicesViewModel {
        return ServicesViewModel(services: services)
    }
}
