//
//  HotDealModel.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/10/17.
//

import Foundation

// MARK: - HotDealModel
struct HotDealModel: Codable {
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

//// MARK: - CustomAttribute
//struct CustomAttribute: Codable {
//    let attributeCode: String
//    let value: Value
//
//    enum CodingKeys: String, CodingKey {
//        case attributeCode = "attribute_code"
//        case value
//    }
//}
//
//enum Value: Codable {
//    case string(String)
//    case stringArray([String])
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if let x = try? container.decode([String].self) {
//            self = .stringArray(x)
//            return
//        }
//        if let x = try? container.decode(String.self) {
//            self = .string(x)
//            return
//        }
//        throw DecodingError.typeMismatch(Value.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Value"))
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        switch self {
//        case .string(let x):
//            try container.encode(x)
//        case .stringArray(let x):
//            try container.encode(x)
//        }
//    }
//}
//
//// MARK: - ExtensionAttributes
//struct ExtensionAttributes: Codable {
//    let websiteIDS: [Int]
//    let categoryLinks: [CategoryLink]
//    let customEntities: [JSONAny]
//
//    enum CodingKeys: String, CodingKey {
//        case websiteIDS = "website_ids"
//        case categoryLinks = "category_links"
//        case customEntities = "custom_entities"
//    }
//}
//
//// MARK: - ProductLink
//struct ProductLink: Codable {
//    let sku: Sku
//    let linkType: LinkType
//    let linkedProductSku: String
//    let linkedProductType: TypeID
//    let position: Int
//
//    enum CodingKeys: String, CodingKey {
//        case sku
//        case linkType = "link_type"
//        case linkedProductSku = "linked_product_sku"
//        case linkedProductType = "linked_product_type"
//        case position
//    }
//}
//
//// MARK: - CategoryLink
//struct CategoryLink: Codable {
//    let position: Int
//    let categoryID: String
//
//    enum CodingKeys: String, CodingKey {
//        case position
//        case categoryID = "category_id"
//    }
//}
