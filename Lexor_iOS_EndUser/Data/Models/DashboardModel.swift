//
//  DashboardModel.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/07/15.
//

import Foundation

// MARK: - DashboardModel
struct DashboardModel: Codable {
    let ads: [AdModel]
    let hotDeals, vipServices: [ProductModel]
    let bestArtists: [AdModel]
    let smallTalks: [SmallTalkModel]

    enum CodingKeys: String, CodingKey {
        case ads
        case hotDeals = "hot_deals"
        case vipServices = "vip_services"
        case bestArtists = "best_artists"
        case smallTalks = "small_talks"
    }
}
