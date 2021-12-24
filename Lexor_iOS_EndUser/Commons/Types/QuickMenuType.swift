//
//  QuickMenuType.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/05/25.
//

import UIKit

enum QuickMenuType: Int, CaseIterable {
    case vouchers , checkIn, reviews, getFreePoints, favorites, trends
         
    
    var title: String {
        switch self {
        case .vouchers:
            return "Vouchers"
        case .checkIn:
            return "Check In"
        case .reviews:
            return "Reviews"
        case .getFreePoints:
            return "Get Free Points"
        case .favorites:
            return "Favorites"
        case .trends:
            return "Trends"
        }
    }
    
    var image: UIImage {
        switch self {
        case .vouchers:
            return #imageLiteral(resourceName: "voucher")
        case .checkIn:
            return #imageLiteral(resourceName: "checkin")
        case .reviews:
            return #imageLiteral(resourceName: "review")
        case .getFreePoints:
            return #imageLiteral(resourceName: "get_free_points")
        case .favorites:
            return #imageLiteral(resourceName: "favorite")
        case .trends:
            return #imageLiteral(resourceName: "trends")
        }
    }
}
