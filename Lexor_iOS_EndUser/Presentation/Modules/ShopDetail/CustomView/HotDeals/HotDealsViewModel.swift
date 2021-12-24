//
//  HotDealsViewModel.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. VN.Danang on 7/2/21.
//

import Foundation

final class HotDealsViewModel {

    // MARK: - Properties
    private let hotDeals: [Service]

    // MARK: - Init
    init(hotDeals: [Service]) {
        self.hotDeals = hotDeals
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        hotDeals.count
    }
    
    func viewModelForRow(at indexPath: IndexPath) -> HotDealCellViewModel? {
        guard let service = hotDeals[safe: indexPath.row] else { return nil }
        return HotDealCellViewModel(service: service)
    }
}
