//
//  Formatter+Ext.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. VN.Danang on 7/14/21.
//

import Foundation

extension DateFormatter {
    static var apiDateFormatter: DateFormatter {
        let serverDateFormatter = DateFormatter()
        serverDateFormatter.calendar = Calendar(identifier: .gregorian)
        serverDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        serverDateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        return serverDateFormatter
    }

    static var normalDateFormatter: DateFormatter {
        let serverDateFormatter = DateFormatter()
        serverDateFormatter.calendar = Calendar(identifier: .gregorian)
        serverDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        serverDateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
        return serverDateFormatter
    }
}

extension DateFormatter {
    
    enum FormatType: String {
        case full = "yyyy-MM-dd'T'HH:mm:ss-SSSS"
        case dateTime = "yyyy-MM-dd HH:mm:ss"
        case dMsYSpace = "dd MMM yyyy"
    }
    
    private static let dateFormatter: DateFormatter = {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }()
    
    static func withUTCTimeZone() -> DateFormatter {
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter
    }
    
    static func withUTCTimeZone(withFormat type: FormatType) -> DateFormatter {
        dateFormatter.dateFormat = type.rawValue
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter
    }
    
    static func withLocalTimeZone() -> DateFormatter {
        dateFormatter.timeZone = .current
        return dateFormatter
    }
    
    static func withLocalTimeZone(withFormat type: FormatType) -> DateFormatter {
        dateFormatter.dateFormat = type.rawValue
        dateFormatter.timeZone = .current
        return dateFormatter
    }
}
