//
//  JSONCode+Ext.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. VN.Danang on 7/14/21.
//

import UIKit

extension JSONDecoder {
    
    static func customUTC(withFormat type: DateFormatter.FormatType) -> JSONDecoder {
        let decoder: JSONDecoder = JSONDecoder()
        let dateFormatter: DateFormatter = DateFormatter.withUTCTimeZone(withFormat: type)
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
}

extension JSONEncoder {
    
    static func customUTC(withFormat type: DateFormatter.FormatType) -> JSONEncoder {
        let encoder: JSONEncoder = JSONEncoder()
        let dateFormatter: DateFormatter = DateFormatter.withUTCTimeZone(withFormat: type)
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        return encoder
    }
}
