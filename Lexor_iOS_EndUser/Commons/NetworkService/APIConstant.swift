//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import Foundation

struct EndPoint {

    static private var config = Config()

    static var baseUrl: String {
        return config.endPoint
    }
}

struct APIKey {
    static let authorization = "Authorization"
    static let accept = "Accept"
    static let acceptEncoding = "Accept-Encoding"
    static let acceptLanguage = "Accept-Language"
    static let contentType = "Content-Type"
}

struct Constant {
    static let accessToken = "user-accessToken"
    static let launchedAppBefore = "user-launchedAppBefore"
}

typealias APICompletion = (APIResult) -> Void
typealias APICompletionValue<Value> = (Result<Value, Error>) -> Void

enum APIResult {
    case success
    case failure(Error)
}

struct APIErrors {
    static let login = NSError(message: "Can not login. Please try again!")
}
