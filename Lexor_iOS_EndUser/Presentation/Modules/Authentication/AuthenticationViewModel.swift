//
//  AuthenticationViewModel.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. on 5/23/21.
//

import Foundation

struct Country: Decodable, Equatable {
    
    let code: String
    let unicode: String
    let name: String
    let emoji: String
}

enum AuthenticationField: Int {
    case header = 9, first, last, mobile, email, password, confirm, postalcode, country, forgot, login, signup, footer
    
    var title: String {
        switch self {
        case .first: return "First Name"
        case .last: return "Last Name"
        case .mobile: return "Mobile Number"
        case .email: return "Email Address"
        case .password: return "Password"
        case .confirm: return "Confirm Password"
        case .postalcode: return "Postal Code"
        default: return ""
        }
    }
}

enum AuthenticationScreen {
    case login, signup
    
    var fields: [AuthenticationField] {
        switch self {
        case .login: return [.email, .password, .forgot, .login, .signup]
        case .signup: return [.header, .first, .last, .mobile, .email, .password, .confirm, .postalcode, .country, .footer]
        }
    }
    
    var barTitle: String {
        switch self {
        case .login: return "Log In"
        case .signup: return "Next"
        }
    }
}

final class AuthenticationViewModel {
    
    private let validator = AuthenticationValidator()
    private let screen: AuthenticationScreen
    let countries: [Country]
    var firstName: String = "" {
        didSet {
            validateWhenValueChanged?()
        }
    }
    var lastName: String = "" {
        didSet {
            validateWhenValueChanged?()
        }
    }
    var mobile: String = ""
    var email: String = "" {
        didSet {
            validateWhenValueChanged?()
        }
    }
    var password: String = "" {
        didSet {
            validateWhenValueChanged?()
        }
    }
    var confirm: String = "" {
        didSet {
            validateWhenValueChanged?()
        }
    }
    var postalcode: String = ""
    var countrySelectedIndex: Int = -1
    
    var validateWhenValueChanged: (() -> Void)?
    
    init(screen: AuthenticationScreen) {
        let data = Data(fromFile: "Countries")
        let decoder = JSONDecoder()
        do {
            countries = try decoder.decode([Country].self, from: data)
            countrySelectedIndex = countries.firstIndex(where: { $0.code == "US" }).unwrapped(or: -1)
        } catch {
            fatalError("Invalid json format")
        }
        self.screen = screen
    }
    
    func validate() throws {
        switch screen {
        case .login:
            try validator.validateEmail(with: email)
            try validator.validateIfNotEmpty(for: .password, with: password)
        case .signup:
            try validator.validateIfNotEmpty(for: .first, with: firstName)
            try validator.validateIfNotEmpty(for: .last, with: lastName)
            try validator.validateEmail(with: email)
            try validator.validatePassword(with: password)
            try validator.validateMatching(with: confirm, target: password)
        }
    }
    
    func login(completion: @escaping APICompletion) {
        NetworkService.shared.login(username: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let value):
                    let token = value.trimmedQuote()
                    if token.isEmpty {
                        completion(.failure(APIErrors.login))
                    } else {
                        AccountManager.shared.token = value
                        completion(.success)
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func signup(completion: @escaping APICompletion) {
        let customer = Customer(email: email, firstname: firstName, lastname: lastName, postcode: postalcode, telephone: mobile, country: countries[safe: countrySelectedIndex])
        NetworkService.shared.register(customer: customer, password: password) { [weak self] result in
            DispatchQueue.main.async {
                guard let this = self else { return }
                switch result {
                case .success:
                    this.login(completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
