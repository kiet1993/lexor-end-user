//
//  DetailsViewModel.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. VN.Danang on 7/2/21.
//

import Foundation

final class DetailsViewModel {

    private let output: ShopDetailViewModel.Output
    
    init(output: ShopDetailViewModel.Output) {
        self.output = output
    }
    
    var name: String {
        return output.name
    }
    
    var address: String {
        return output.address
    }
    
    var coordinates: Coordinates {
        return output.coordinates
    }
    
    var phone: String {
        return "1900 9095"
    }
    
    func technician(at index: Int) -> Technician? {
        return output.technicians[safe: index]
    }
    
    func opening(at index: Int) -> String {
        if let opening = output.openings[safe: index] {
            return [opening.start, opening.end].joined(separator: " - ")
        }
        return "--"
    }
}
