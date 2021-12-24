//
//  ServicesViewModel.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. VN.Danang on 6/3/21.
//

import Foundation

final class ServicesViewModel {
    
    private let originalServices: [Service]
    private var services: [Service]
    
    init(services: [Service]) {
        originalServices = services
        self.services = services
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        return services.count
    }
    
    func viewModelForRow(at indexPath: IndexPath) -> ServiceCellViewModel? {
        guard let service = services[safe: indexPath.row] else { return nil }
        return ServiceCellViewModel(service: service)
    }
    
    func search(for keyword: String, completion: () -> Void) {
        if keyword.isEmpty {
            services = originalServices
        } else {
            services = originalServices.filter { $0.name.lowercased().contains(keyword.lowercased()) }
        }
        completion()
    }
}
