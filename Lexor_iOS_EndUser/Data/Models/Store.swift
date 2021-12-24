//
//  Store.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. VN.Danang on 7/12/21.
//

import UIKit

struct Store: Decodable {
    
    let id: Int
    let name: String
    let storeExtension: StoreExtension

    enum CodingKeys: String, CodingKey {
        case id, name
        case storeExtension = "extension_attributes"
    }
    
    var address: String {
        return [storeExtension.address.street.first, storeExtension.address.city]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
    
    var workHours: String {
        return storeExtension.openings.first
            .map { [$0.start, $0.end].joined(separator: " - ") }
            .orEmpty
    }
}

struct StoreExtension: Decodable {
    let address: Address
    let openings: [StoreOpeningHour]
    let specialOpenings: [StoreOpeningHour]
    
    enum CodingKeys: String, CodingKey {
        case address
        case opening = "opening_hours"
        case specialOpening = "special_opening_hours"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        address = try container.decode(Address.self, forKey: .address)
        openings = (try? container.decode([[StoreOpeningHour]].self, forKey: .opening)).unwrapped(or: [[]]).flatMap { $0 }
        specialOpenings = (try? container.decode([[StoreOpeningHour]].self, forKey: .specialOpening)).unwrapped(or: [[]]).flatMap { $0 }
    }
}

struct StoreOpeningHour: Decodable {
    let start: String
    let end: String
    
    enum CodingKeys: String, CodingKey {
        case start = "start_time"
        case end = "end_time"
    }
}
