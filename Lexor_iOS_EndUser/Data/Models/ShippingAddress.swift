//
//  ShippingAddress.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 7/24/21.
//

import Foundation

// MARK: - Welcome
struct ShippingAddress: Codable {
    let addressInformation: AddressInformation
}

// MARK: - AddressInformation
struct AddressInformation: Codable {
    let shippingAddress, billingAddress: IngAddress
    let shippingMethodCode, shippingCarrierCode: String

    enum CodingKeys: String, CodingKey {
        case shippingAddress, billingAddress
        case shippingMethodCode = "shipping_method_code"
        case shippingCarrierCode = "shipping_carrier_code"
    }
}

// MARK: - IngAddress
struct IngAddress: Codable {
    let region: String
    let regionID: Int
    let countryID: String
    let street: [String]
    let company, telephone, postcode, city: String
    let firstname, lastname, email, ingAddressPrefix: String
    let regionCode: String
    let sameAsBilling: Int?

    enum CodingKeys: String, CodingKey {
        case region
        case regionID = "region_id"
        case countryID = "country_id"
        case street, company, telephone, postcode, city, firstname, lastname, email
        case ingAddressPrefix = "prefix"
        case regionCode = "region_code"
        case sameAsBilling
    }
}
