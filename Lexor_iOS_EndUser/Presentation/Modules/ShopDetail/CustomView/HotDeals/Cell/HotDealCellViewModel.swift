//
//  HotDealCellViewModel.swift
//  Lexor_iOS_EndUser
//
//  Created by Harosc on 10/23/21.
//

import Foundation

final class HotDealCellViewModel {
    
    let service: Service
    
    init(service: Service) {
        self.service = service
    }
    
    var name: String {
        return service.name
    }
    
    var price: String {
        return String(format: "$%.2f", service.price)
    }
}
