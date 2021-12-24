//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import UIKit

protocol KeychainServiceManagerType: AnyObject {
    func saveAccessToken(accessToken: String?)
    func retriveAccessToken() -> String?
}

class KeychainServiceManager: KeychainServiceManagerType {
    func saveAccessToken(accessToken: String?) {
        saveToKeychain(key: Constant.accessToken, content: accessToken)
    }

    func retriveAccessToken() -> String? {
        retriveFromKeychain(key: Constant.accessToken)
    }

    func removeAccessToken() {
        removeKeychainOf(key: Constant.accessToken)
    }

    private func saveToKeychain(key: String, content: String?) {
        guard let content = content?.data(using: String.Encoding.utf8) else {
            return
        }
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key,
                                    kSecValueData as String: content]
        if retriveFromKeychain(key: key) == nil {
            let status = SecItemAdd(query as CFDictionary, nil)
            guard status == errSecSuccess else {
                fatalError("Save \(key) to Keychain failed!!!")
            }
        }
    }

    private func retriveFromKeychain(key: String) -> String? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnData as String: kCFBooleanTrue ?? true]

        var retrivedData: AnyObject?
        _ = SecItemCopyMatching(query as CFDictionary, &retrivedData)

        guard let data = retrivedData as? Data else { return nil }
        return String(data: data, encoding: String.Encoding.utf8)
    }

    private func removeKeychainOf(key: String) {
        let queryDictionary: [String: Any] = [kSecClass as String: kSecClassGenericPassword as String,
                                              kSecAttrAccount as String: key]

        if retriveFromKeychain(key: key) != nil {
            let status = SecItemDelete(queryDictionary as CFDictionary)
            guard status == errSecSuccess || status == errSecItemNotFound else {
                fatalError("Delete \(key) from Keychain failed!!!")
            }
        }
    }
}
