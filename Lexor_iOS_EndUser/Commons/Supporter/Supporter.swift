//
//  Supporter.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 7/5/21.
//

import Foundation

final class Supporter {

    static let shared = Supporter()

    private init() {}

    private(set) lazy var moneyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.maximumFractionDigits = 0
        formatter.currencySymbol = "$"
        formatter.negativeFormat = formatter.currencySymbol + formatter.minusSign
        formatter.currencyGroupingSeparator = "."
        formatter.currencyDecimalSeparator = ","
        formatter.positiveSuffix = ""
        formatter.negativeSuffix = ""
        return formatter
    }()
}
