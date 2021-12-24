//
//  BaseResponseModel.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/10/14.
//

import Foundation

// MARK: - BaseResponseModel
struct BaseResponseModel<T: Codable>: Codable {
    let items: [T]
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case items
        case totalCount = "total_count"
    }
}


// MARK: - Item
struct ShopItemModel: Codable {
    let extensionAttributes: ExtensionAttributes
    let id: Int
    let name: String
    let isActive: Bool
    let sellerCode, createdAt, updatedAt, attributeSetName: String
    let mediaPath: String

    enum CodingKeys: String, CodingKey {
        case extensionAttributes = "extension_attributes"
        case id, name
        case isActive = "is_active"
        case sellerCode = "seller_code"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case attributeSetName = "attribute_set_name"
        case mediaPath = "media_path"
    }
}

// MARK: - ExtensionAttributes
struct ExtensionAttributes: Codable {
    let address: Address
    let openingHours: [[OpeningHour]]
    let specialOpeningHours: [JSONAny]

    enum CodingKeys: String, CodingKey {
        case address
        case openingHours = "opening_hours"
        case specialOpeningHours = "special_opening_hours"
    }
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let latitude, longitude: Double
}

// MARK: - OpeningHour
struct OpeningHour: Codable {
    let startTime, endTime: String

    enum CodingKeys: String, CodingKey {
        case startTime = "start_time"
        case endTime = "end_time"
    }
}
