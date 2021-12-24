//
//  APITarget.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/10/13.
//

import Moya

enum APITarget {
    case login(username: String, password: String)
    case register(customer: Customer, password: String)
    case store(id: String)
    case paymentMethod
    case cartCreate
    case cartGetInfo
    case cartAddProduct(productInfo: [String: Any])
    case cartBookingOrder(orderInfo: [String: Any])
    case fetchVipServices(currentPage: Int, pageSize: Int)
    case fetchHotDeals(currentPage: Int, pageSize: Int)
    case searchShopName(keyword: String)
    case getStoreServices(id: String, currentPage: Int)
    case getStoreReviews(id: String, currentPage: Int)
    case getStoreHotDeals(id: String)
    case getStoreTechnicians(id: String)
    case fetchTechnicians(currentPage: Int, pageSize: Int)
}

extension APITarget: TargetType {

    // MARK: - Base URL
    var baseURL: URL {
        do {
            switch self {
            case .searchShopName:
                return try "https://salon360.bavaan.com/rest/all/V1".asURL()
            case .cartCreate, .cartGetInfo, .cartAddProduct, .cartBookingOrder, .paymentMethod:
                return try "https://salon360.bavaan.com/rest/default/V1".asURL()
            default:
                return try "https://salon360.bavaan.com/rest/all/V1".asURL()
            }
        } catch {
            fatalError("Please set Base URL")
        }

    }

    // MARK: - Path
    var path: String {
        switch self {
        case .register:
            return "/customers"
        case .login:
            return "/integration/customer/token"
        case .store(let id):
            return "/retailer/\(id)"
        case .paymentMethod:
            return "/carts/mine/payment-methods"
        case .cartCreate:
            return "/carts/mine"
        case .cartGetInfo:
            return "/carts/mine"
        case .cartAddProduct:
            return "/carts/mine/items"
        case .cartBookingOrder:
            return "/carts/mine/payment-information"
        case .searchShopName:
            return "/retailer/search"
        case .fetchHotDeals:
            return "/products/top/hot-deals"
        case .fetchVipServices:
            return "/products/top/vip"
        case .getStoreServices(let id, _):
            return "/retailer/\(id)/products"
        case .getStoreReviews:
            return "/reviews"
        case .getStoreHotDeals(let id):
            return "/retailer/\(id)/products/top/hot-deals"
        case .getStoreTechnicians(let id):
            return "/retailer/\(id)/technicians"
        case .fetchTechnicians:
            return "/retailer/technicians"
        }
    }

    // MARK: - Method
    var method: Moya.Method {
        switch self {
        case .register, .login, .cartCreate, .cartAddProduct, .cartBookingOrder:
            return .post
        default:
            return .get
        }
    }

    // MARK: - Task
    var task: Task {
        switch self {
        case .login(username: let username, password: let password):
            let parameters: [String: Any] = ["username": username, "password": password]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .register(let customer, let password):
            var parameters: [String: Any] = customer.toJSON()
            parameters["password"] = password
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .store:
            return .requestPlain
        case .paymentMethod:
            return .requestPlain
        case .cartCreate:
            return .requestPlain
        case .cartGetInfo:
            return .requestPlain
        case .cartAddProduct(let productInfo):
            let parameters: [String: Any] = productInfo
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .cartBookingOrder(let orderInfo):
            let parameters: [String: Any] = orderInfo
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .fetchHotDeals(let currentPage, let pageSize):
            let parameters = [
                "searchCriteria[currentPage]": currentPage,
                "searchCriteria[pageSize]": pageSize,
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .fetchVipServices(let currentPage, let pageSize):
            let parameters = [
                "searchCriteria[currentPage]": currentPage,
                "searchCriteria[pageSize]": pageSize,
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .searchShopName(let keyword):
            let parameters = [
                "searchCriteria[filterGroups][0][filters][0][field]": "name",
                "searchCriteria[filterGroups][0][filters][0][value]": "%\(keyword)%",
                "searchCriteria[filterGroups][0][filters][0][conditionType]": "like"
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getStoreServices(_, let currentPage):
            let parameters = [
                "searchCriteria[currentPage]": currentPage,
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getStoreReviews(let id, let currentPage):
            let parameters: [String : Any] = [
                "searchCriteria[filterGroups][0][filters][0][field]": "entity_code",
                "searchCriteria[filterGroups][0][filters][0][value]": "retailer",
                "searchCriteria[filterGroups][0][filters][0][conditionType]": "eq",
                "searchCriteria[filterGroups][0][filters][1][field]": "entity_pk_value",
                "searchCriteria[filterGroups][0][filters][1][value]": id,
                "searchCriteria[filterGroups][0][filters][1][conditionType]": "eq",
                "searchCriteria[currentPage]": currentPage,
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getStoreHotDeals:
            return .requestPlain
        case .getStoreTechnicians:
            return .requestPlain
        case .fetchTechnicians(let currentPage, let pageSize):
            let parameters = [
                "searchCriteria[currentPage]": currentPage,
                "searchCriteria[pageSize]": pageSize,
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }

    // MARK: - Validation
    var validationType: ValidationType {
        return .none
    }

    // MARK: - Sample Data
    var sampleData: Data {
        return Data()
    }

    // MARK: - Headers
    var headers: [String: String]? {
        var headers = [
            APIKey.accept: "*/*",
            APIKey.acceptEncoding: "gzip, deflate, br",
            APIKey.acceptLanguage: "en-US",
            APIKey.contentType: "application/json"
        ]
        switch self {
        /*
        case .paymentMethod, .cartCreate, .cartGetInfo:
            if let token = AccountManager.shared.cartUserToken, !token.isEmpty {
                headers[APIKey.authorization] = "Bearer " + token
            }
        */
        default:
            if let token = AccountManager.shared.token, !token.isEmpty {
                headers[APIKey.authorization] = "Bearer " + token
            }
        }
        return headers
    }
}
