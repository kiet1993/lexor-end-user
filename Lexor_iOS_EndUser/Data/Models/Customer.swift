//
//  Customer.swift
//  Lexor_iOS_EndUser
//
//  Created by Harosc on 10/23/21.
//

import Foundation

struct Customer: Decodable {
    
    let email: String
    let firstname: String
    let lastname: String
    let postcode: String?
    let telephone: String?
    let country: Country?
    
    func toJSON() -> [String: Any] {
        var customer: [String: Any] = [
            "email": email,
            "firstname": firstname,
            "lastname": lastname,
        ]
        if !postcode.isNilOrEmpty, !telephone.isNilOrEmpty, let country = country {
            let address: [String: Any] = [
                "firstname": firstname,
                "lastname": lastname,
                "postcode": postcode as Any,
                "street": [country.name],
                "city": country.name,
                "telephone": telephone as Any,
                "country_id": country.name
            ]
            customer["addresses"] = [address]
        }
        return ["customer": customer]
    }
}
