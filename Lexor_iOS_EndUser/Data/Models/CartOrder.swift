//
//  CartOrder.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 10/17/21.
//

import Foundation

// MARK: - CartOrder
struct CartOrder: Codable {
    let email: String
    let paymentMethod: PaymentMethod
    let billingAddress: CartBillingAddress
}

// MARK: - BillingAddress
struct CartBillingAddress: Codable {
    let region: String
    let regionID: Int
    let regionCode, countryID: String
    let street: [String]
    let company, telephone, fax, postcode: String
    let city, firstname, lastname, middlename: String
    let billingAddressPrefix, suffix, vatID: String
    let customerID: Int
    let email: String
    let sameAsBilling, customerAddressID, saveInAddressBook: Int

    enum CodingKeys: String, CodingKey {
        case region
        case regionID = "region_id"
        case regionCode = "region_code"
        case countryID = "country_id"
        case street, company, telephone, fax, postcode, city, firstname, lastname, middlename
        case billingAddressPrefix = "prefix"
        case suffix
        case vatID = "vat_id"
        case customerID = "customer_id"
        case email
        case sameAsBilling = "same_as_billing"
        case customerAddressID = "customer_address_id"
        case saveInAddressBook = "save_in_address_book"
    }
}

// MARK: - PaymentMethod
struct PaymentMethod: Codable {
    let poNumber, method: String
    let additionalData: [String]

    enum CodingKeys: String, CodingKey {
        case poNumber = "po_number"
        case method
        case additionalData = "additional_data"
    }
}
