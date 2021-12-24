//
//  ServiceCellViewModel.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. VN.Danang on 6/3/21.
//

import Foundation

final class ServiceCellViewModel {
    
    let service: Service
    
    init(service: Service) {
        self.service = service
    }
    
    var name: String {
        return service.name
    }
    
    var ages: String {
        return "Ages \(service.ages)"
    }
    
    var price: String {
        return String(format: "$%.2f", service.price)
    }
    
    var time: String {
        return "\(service.time)m"
    }
    
    var deal: String {
        return "SAVE UP TO 10%"
    }
}
