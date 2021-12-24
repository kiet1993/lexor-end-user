//
//  CartAddProductResult.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 10/23/21.
//

import Foundation

// MARK: - CartAddProductResult
struct CartAddProductResult: Codable {
    let itemID: Int
    let sku: String
    let qty: Int
    let name: String
    let price: Int
    let productType, quoteID: String
    let productOption: ProductOption

    enum CodingKeys: String, CodingKey {
        case itemID = "item_id"
        case sku, qty, name, price
        case productType = "product_type"
        case quoteID = "quote_id"
        case productOption = "product_option"
    }
}

// MARK: - ProductOption
struct ProductOption: Codable {
    let extensionAttributes: CartProdExtensionAttributes

    enum CodingKeys: String, CodingKey {
        case extensionAttributes = "extension_attributes"
    }
}

// MARK: - ExtensionAttributes
struct CartProdExtensionAttributes: Codable {
    let reservationOptions: ReservationOptions

    enum CodingKeys: String, CodingKey {
        case reservationOptions = "reservation_options"
    }
}

// MARK: - ReservationOptions
struct ReservationOptions: Codable {
    let retailerID, technicianID: Int
    let designIDS: [Int]
    let date, startTime, endTime, note: String

    enum CodingKeys: String, CodingKey {
        case retailerID = "retailer_id"
        case technicianID = "technician_id"
        case designIDS = "design_ids"
        case date
        case startTime = "start_time"
        case endTime = "end_time"
        case note
    }
}
