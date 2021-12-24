//
//  CartOderPaymentMethod.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 10/23/21.
//

import Foundation

// MARK: - CartOderPaymentMethod
struct CartOderPaymentMethod: Codable {
    let code, title: String
}

typealias CartOderPaymentMethodResult = [CartOderPaymentMethod]
