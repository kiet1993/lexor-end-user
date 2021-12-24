//
//  CartOrderResult.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 10/23/21.
//

import Foundation

// MARK: - CartOrderResult
struct CartOrderResult: Codable {
    let id: Int
    let createdAt, updatedAt: String
    let isActive, isVirtual: Bool
    let items: [Item]
    let itemsCount, itemsQty: Int
    let customer: CartOrderCustomer
    let billingAddress: OrderBillingAddress
    let origOrderID: Int
    let currency: Currency
    let customerIsGuest, customerNoteNotify: Bool
    let customerTaxClassID, storeID: Int
    let extensionAttributes: WelcomeExtensionAttributes

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isActive = "is_active"
        case isVirtual = "is_virtual"
        case items
        case itemsCount = "items_count"
        case itemsQty = "items_qty"
        case customer
        case billingAddress = "billing_address"
        case origOrderID = "orig_order_id"
        case currency
        case customerIsGuest = "customer_is_guest"
        case customerNoteNotify = "customer_note_notify"
        case customerTaxClassID = "customer_tax_class_id"
        case storeID = "store_id"
        case extensionAttributes = "extension_attributes"
    }
}

// MARK: - BillingAddress
struct OrderBillingAddress: Codable {
    let id: Int
    let region: String
    let regionID: Int
    let regionCode, countryID: String
    let street: [String]
    let telephone, postcode, city, firstname: String
    let lastname: String
    let customerID: Int
    let email: String
    let sameAsBilling, customerAddressID, saveInAddressBook: Int

    enum CodingKeys: String, CodingKey {
        case id, region
        case regionID = "region_id"
        case regionCode = "region_code"
        case countryID = "country_id"
        case street, telephone, postcode, city, firstname, lastname
        case customerID = "customer_id"
        case email
        case sameAsBilling = "same_as_billing"
        case customerAddressID = "customer_address_id"
        case saveInAddressBook = "save_in_address_book"
    }
}

// MARK: - Customer
struct CartOrderCustomer: Codable {
    let id, groupID: Int
    let defaultBilling, defaultShipping, createdAt, updatedAt: String
    let createdIn, dob, email, firstname: String
    let lastname: String
    let gender, storeID, websiteID: Int
    let addresses: [OrderAddress]
    let disableAutoGroupChange: Int
    let extensionAttributes: CustomerExtensionAttributes

    enum CodingKeys: String, CodingKey {
        case id
        case groupID = "group_id"
        case defaultBilling = "default_billing"
        case defaultShipping = "default_shipping"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case createdIn = "created_in"
        case dob, email, firstname, lastname, gender
        case storeID = "store_id"
        case websiteID = "website_id"
        case addresses
        case disableAutoGroupChange = "disable_auto_group_change"
        case extensionAttributes = "extension_attributes"
    }
}

// MARK: - Address
struct OrderAddress: Codable {
    let id, customerID: Int
    let region: Region
    let regionID: Int
    let countryID: String
    let street: [String]
    let telephone, postcode, city, firstname: String
    let lastname: String
    let defaultShipping, defaultBilling: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case region
        case regionID = "region_id"
        case countryID = "country_id"
        case street, telephone, postcode, city, firstname, lastname
        case defaultShipping = "default_shipping"
        case defaultBilling = "default_billing"
    }
}

// MARK: - Region
struct Region: Codable {
    let regionCode, region: String
    let regionID: Int

    enum CodingKeys: String, CodingKey {
        case regionCode = "region_code"
        case region
        case regionID = "region_id"
    }
}

// MARK: - CustomerExtensionAttributes
struct CustomerExtensionAttributes: Codable {
    let isSubscribed: Bool

    enum CodingKeys: String, CodingKey {
        case isSubscribed = "is_subscribed"
    }
}

// MARK: - WelcomeExtensionAttributes
struct WelcomeExtensionAttributes: Codable {
    let shippingAssignments: [JSONAny]

    enum CodingKeys: String, CodingKey {
        case shippingAssignments = "shipping_assignments"
    }
}

// MARK: - Item
struct Item: Codable {
    let itemID: Int
    let sku: String
    let qty: Int
    let name: String
    let price: Int
    let productType, quoteID: String

    enum CodingKeys: String, CodingKey {
        case itemID = "item_id"
        case sku, qty, name, price
        case productType = "product_type"
        case quoteID = "quote_id"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
