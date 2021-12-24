//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import UIKit

class AccountManager {
    
    static let shared = AccountManager()
    
    private init() {}

    static let keychainManager = KeychainServiceManager()
    
    var token: String? {
        get {
            return AccountManager.keychainManager.retriveAccessToken()
        }
        set {
            if let token = newValue, !token.isEmpty {
                AccountManager.keychainManager.saveAccessToken(accessToken: token)
            } else {
                AccountManager.keychainManager.removeAccessToken()
            }
        }
    }
    var shouldLogin: Bool {
        return token.isNilOrEmpty
    }

    var cartID: Int?
}
