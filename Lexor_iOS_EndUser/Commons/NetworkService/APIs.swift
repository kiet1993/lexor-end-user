//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import Moya
import UIKit

enum APIs {
    case login(username: String, password: String)
    case register(customer: Customer, password: String)
    case store(id: String)
    case fetchDashboard
    case paymentMethod
    case cartCreate
    case cartOrderDummyAPI(cartOrderParam: [String: Any])
    case cartGetInfo
    case cartAddShippingAddress(shippingInfo: [String: Any])
    case cartAddProduct(productInfo: [String: Any])
    case cartRemoveProduct(productID: String)
    case cartOrder(cartID: String, paymentMethod: [String: Any])
    case cartShipMethod(cartID: String)
    case customerToken(userName: String, password: String)
    case search(keyword: String)
}

extension APIs: TargetType {

    // MARK: - Base URL
    public var baseURL: URL {
        do {
            switch self {
            case .cartOrderDummyAPI:
                return try "https://inte-lexor-salon-360-api.azurewebsites.net".asURL()
            default:
                return try EndPoint.baseUrl.asURL()
            }
        } catch {
            fatalError("Please set Base URL")
        }

    }

    // MARK: - Path
    public var path: String {
        switch self {
        case .register:
            return "/rest/all/V1/customers"
        case .login:
            return "/rest/V1/integration/customer/token"
        case .store:
            return "/api/app/store"
        case .fetchDashboard:
            return "/api/app/dashboard"
        case .paymentMethod:
            return "/rest/all/V1/carts/mine/payment-methods"
        case .cartCreate:
            return "/rest/all/V1/carts/mine"
        case .cartGetInfo:
            return "/rest/all/V1/carts/mine"
        case .cartAddShippingAddress:
            return "/rest/all/V1/carts/mine/shipping-information"
        case .cartAddProduct:
            return "/rest/all/V1/carts/mine/items"
        case .cartRemoveProduct(let productID):
            return "/rest/all/V1/carts/mine/items/" + productID
        case .cartOrder:
            return "/rest/all/V1/carts/mine/order"
        case .cartShipMethod(let cartID):
            return "/rest/all/V1/carts/mine/shipping-methods?id=" + cartID
        case .customerToken:
            return "/rest/V1/integration/customer/token"
        case .search(let keyword):
            return "/api/app/stores"
        case .cartOrderDummyAPI:
            return "/v1/salon_sale_order"
        }
    }

    // MARK: - Method
    public var method: Moya.Method {
        switch self {
        case .register, .login, .cartCreate, .cartAddShippingAddress, .cartAddProduct, .customerToken, .cartOrderDummyAPI:
            return .post
        case .cartRemoveProduct:
            return .delete
        case .cartOrder:
            return .put
        default:
            return .get
        }
    }

    // MARK: - Task
    public var task: Task {
        switch self {
        case .login(username: let username, password: let password):
            let parameters: [String: Any] = ["username": username, "password": password]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .register(let customer, let password):
            var parameters: [String: Any] = customer.toJSON()
            parameters["password"] = password
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .store(id: let id):
            let parameters: [String: Any] = ["id": id]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .search(let keyword):
            return .requestParameters(parameters: ["keyword": keyword], encoding: URLEncoding.default)
        case .fetchDashboard:
            return .requestPlain
        case .paymentMethod:
            return .requestPlain
        case .cartCreate:
            return .requestPlain
        case .cartGetInfo:
            return .requestPlain
        case .cartAddShippingAddress(let shippingInfo):
            let parameters: [String: Any] = shippingInfo
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .cartAddProduct(let productInfo):
            let parameters: [String: Any] = productInfo
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .cartRemoveProduct:
            return .requestPlain
        case .cartOrder(let cartID, let paymentMethod):
            let parameters: [String: Any] = ["id": cartID, "paymentMethod": paymentMethod]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .cartShipMethod(let cartID):
            let parameters: [String: Any] = ["id": cartID]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .customerToken(let userName, let password):
            let parameters: [String: Any] = ["username": userName, "password": password]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .cartOrderDummyAPI(let param):
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        }
    }

    // MARK: - Validation
    public var validationType: ValidationType {
        return .none
    }

    // MARK: - Sample Data
    public var sampleData: Data {
        return Data()
    }

    // MARK: - Headers
    public var headers: [String: String]? {
        var headers = [
            APIKey.accept: "*/*",
            APIKey.acceptEncoding: "gzip, deflate, br",
            APIKey.acceptLanguage: "en-US",
            APIKey.contentType: "application/json"
        ]
        switch self {
        case .paymentMethod, .cartCreate, .cartGetInfo, .cartAddShippingAddress, .cartAddProduct, .cartRemoveProduct, .cartOrder, .cartShipMethod:
            if let token = AccountManager.shared.token, !token.isEmpty {
                headers[APIKey.authorization] = "Bearer " + token
            }
        default:
            if let token = AccountManager.shared.token, !token.isEmpty {
                headers[APIKey.authorization] = "Bearer " + token
            }
        }
        return headers
    }
}
