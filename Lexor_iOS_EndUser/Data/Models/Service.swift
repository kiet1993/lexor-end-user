//
//  Service.swift
//  Lexor_iOS_EndUser
//
//  Created by Harosc on 10/22/21.
//

import Foundation

struct Service: Codable {
    let id: Int
    let sku: String
    let name: String
    let price: Double
    let updatedDate: Date?
    let attributes: [StoreServiceAttribute]

    enum CodingKeys: String, CodingKey {
        case id, name, price, sku
        case updatedDate = "updated_at"
        case attributes = "custom_attributes"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        sku = try container.decode(String.self, forKey: .sku)
        name = try container.decode(String.self, forKey: .name)
        price = (try? container.decodeIfPresent(Double.self, forKey: .price)).unwrapped(or: 0)
        updatedDate = try? container.decodeIfPresent(Date.self, forKey: .updatedDate)
        attributes = (try? container.decodeIfPresent([StoreServiceAttribute].self, forKey: .attributes)).unwrapped(or: [])
    }
    
    var ages: String {
        let minAge = (attributes.first(where: { $0.code == "reservation_min_age" })?.value).orEmpty
        let maxAge = (attributes.first(where: { $0.code == "reservation_max_age" })?.value).orEmpty
        return minAge + "-" + maxAge
    }
    
    var time: String {
        return (attributes.first(where: { $0.code == "reservation_time" })?.value).unwrapped(or: "--")
    }
}

struct StoreServiceAttribute: Codable {
    let code: String
    let value: String?
    
    enum CodingKeys: String, CodingKey {
        case code = "attribute_code"
        case value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        value = try? container.decodeIfPresent(String.self, forKey: .value)
    }
}
