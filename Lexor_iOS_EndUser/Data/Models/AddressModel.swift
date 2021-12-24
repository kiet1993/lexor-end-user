//
//  AddressModel.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/10/14.
//

import Foundation

// MARK: - Address
struct Address: Codable {
    let id, retailerID: Int?
    let coordinates: Coordinates
    let regionID: Int
    let countryID: String
    let street: [String]
    let postcode, city: String

    enum CodingKeys: String, CodingKey {
        case id
        case retailerID = "retailer_id"
        case coordinates
        case regionID = "region_id"
        case countryID = "country_id"
        case street, postcode, city
    }
}
