//
//  NetworkError.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/10/12.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case expiredToken
    case unknown
    
    var value: String {
        return String(describing: self)
    }
    
    var errorDescription: String? {
        switch self {
        case .expiredToken:
            return "A expired token error occurred"
        case .unknown:
            return "A unknown error occurred"
        }
    }
}
