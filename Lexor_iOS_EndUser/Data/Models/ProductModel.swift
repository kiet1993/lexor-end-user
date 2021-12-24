//
//  ProductModel.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/07/15.
//

import Foundation

struct ProductModel: Codable {
    let id: Int
//    let sku: Sku
    let name: String
    let attributeSetID, price, status, visibility: Int
//    let typeID: TypeID
    let createdAt, updatedAt: String
//    let extensionAttributes: ExtensionAttributes
//    let productLinks: [ProductLink]
//    let options: [JSONAny]
//    let mediaGalleryEntries: [MediaGalleryEntry]
//    let tierPrices: [JSONAny]
//    let customAttributes: [CustomAttribute]

    enum CodingKeys: String, CodingKey {
        case id, name
        case attributeSetID = "attribute_set_id"
        case price, status, visibility
//        case typeID = "type_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
//        case extensionAttributes = "extension_attributes"
//        case productLinks = "product_links"
//        case options
//        case mediaGalleryEntries = "media_gallery_entries"
//        case tierPrices = "tier_prices"
//        case customAttributes = "custom_attributes"
    }
}
