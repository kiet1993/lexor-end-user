//
//  AuthenticationValidator.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. on 5/24/21.
//

import Foundation

enum AuthenticationError: Error {
    case empty(field: AuthenticationField)
    case invalid(field: AuthenticationField)
    case custom(message: String)

    var localizedDescription: String {
        switch self {
        case .empty(let field):
            return "\(field.title) is required"
        case .invalid(let field):
            return "\(field.title) is incorrect format"
        case .custom(let message):
            return message
        }
    }
}

final class AuthenticationValidator {
    
    func validateEmail(with value: String) throws {
        if value.isEmpty {
            throw AuthenticationError.empty(field: .email)
        }
        if !value.isValidEmail() {
            throw AuthenticationError.invalid(field: .email)
        }
    }
    
    func validatePassword(with value: String) throws {
        if value.isEmpty {
            throw AuthenticationError.empty(field: .password)
        }
        if value.count < 8 {
            throw AuthenticationError.custom(message: "Password needs at least 8 characters")
        }
        var count: Int = 0
        [".*[a-z]+.*", ".*[A-Z]+.*", ".*[0-9]+.*", ".*[!&^%$#@()/]+.*"].forEach { regex in
            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
            if predicate.evaluate(with: value) { count += 1 }
        }
        if count < 3 {
            throw AuthenticationError.custom(message: "Minimum of different classes of characters in password is %1. Classes of characters: Lower Case, Upper Case, Digits, Special Characters")
        }
    }
    
    func validateMatching(with value: String, target: String) throws {
        if value != target {
            throw AuthenticationError.custom(message: "Password and comfirmation password do not match")
        }
    }
    
    func validateIfNotEmpty(for field: AuthenticationField, with value: String) throws {
        if value.isEmpty {
            throw AuthenticationError.empty(field: field)
        }
    }
    
    func validateNumber(for field: AuthenticationField, with value: String) throws {
        if Int(value) == nil {
            throw AuthenticationError.invalid(field: field)
        }
    }
}
