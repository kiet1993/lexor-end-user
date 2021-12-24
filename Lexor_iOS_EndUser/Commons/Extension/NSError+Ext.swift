//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import UIKit

public extension NSError {
    var isInternetConnectionError: Bool {
        if domain == NSURLErrorDomain && [NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost].contains(code) {
            return true
        }
        return false
    }
}

extension NSError {
    
    convenience init(domain: String? = nil, code: Int = -999, message: String) {
        let domain: String = domain.orEmpty
        let userInfo: [String: String] = [NSLocalizedDescriptionKey: message]
        self.init(domain: domain, code: code, userInfo: userInfo)
    }
}

extension Error {
    
    var message: String {
        localizedDescription
    }
}
