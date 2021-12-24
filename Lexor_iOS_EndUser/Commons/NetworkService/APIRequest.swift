//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import Moya
import Alamofire
import UIKit

class DefaultAlamofireManager: Alamofire.Session {
    static let sharedManager: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5 // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = 20 // as seconds, you can set your resource timeout
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return DefaultAlamofireManager(configuration: configuration)
    }()
}

private func JSONResponseDataFormatter(_ data: Data) -> String {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return String(data: prettyData, encoding: .utf8).unwrapped(or: String(data: data, encoding: .utf8).orEmpty)
    } catch {
        return String(data: data, encoding: .utf8).orEmpty
    }
}

private let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        request.timeoutInterval = 300
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

private let apiProvider = MoyaProvider<APIs>(
    requestClosure: requestClosure,
    plugins: [NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: JSONResponseDataFormatter),
                                                       logOptions: [.requestMethod,
                                                                    .requestHeaders,
                                                                    .requestBody,
                                                                    .formatRequestAscURL,
                                                                    .successResponseBody,
                                                                    .errorResponseBody]))]
)

class APIRequest {
    @discardableResult
    private static func request<T: Decodable>(targetAPI: APIs,
                                              completion: @escaping (Result<T, Error>) -> Void) -> Cancellable {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.apiDateFormatter)

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        return apiProvider.request(targetAPI) { (moyaResult) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            let result: Swift.Result<T, Error>
            switch moyaResult {
            case .failure(let moyaError):
                result = Swift.Result<T, Error>.failure(moyaError.underlyingError)
            case .success(let moyaResponse):
                do {
                    let appObject: AppResponse<T> = try moyaResponse.map(AppResponse<T>.self, using: jsonDecoder, failsOnEmptyData: false)
                    if let objResult = appObject.data {
                        result = Swift.Result<T, Error>.success(objResult)
                    } else {
                        let error = self.responseObjectToError(responseObj: appObject)
                        result = Swift.Result<T, Error>.failure(error.underlyingError)
                    }
                } catch let error {
                    guard let moyaError = error as? MoyaError else {
                        fatalError("Imposible case")
                    }
                    result = Swift.Result<T, Error>.failure(moyaError.underlyingError)
                }
            }
            completion(result)
        }
    }

    @discardableResult
    private static func requestVoid(targetAPI: APIs, completionHandler: @escaping (Swift.Result<Void, Error>) -> Void) -> Cancellable {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.apiDateFormatter)

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        return apiProvider.request(targetAPI) { moyaResult in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            let result: Swift.Result<Void, Error>
            switch moyaResult {
            case .success(let response):
                do {
                    let responseObject: ResponseVoid = try response.map(ResponseVoid.self, atKeyPath: nil, using: jsonDecoder, failsOnEmptyData: false)
                    if (200...299).contains(responseObject.status ?? 200) {
                        result = Swift.Result<Void, Error>.success(())
                    } else {
                        let error = self.responseObjectToError(responseObj: responseObject)
                        result = Swift.Result<Void, Error>.failure(error.underlyingError)
                    }
                } catch let error {
                    guard let moyaError = error as? MoyaError else {
                        fatalError("Imposible case")
                    }
                    result = Swift.Result<Void, Error>.failure(moyaError.underlyingError)
                }
            case .failure(let error):
                result = Swift.Result<Void, Error>.failure(error.underlyingError)
            }
            completionHandler(result)
        }
    }

    private static func responseObjectToError(responseObj: ResponseVoid) -> MoyaError {
        let errorMsg = responseObj.message.unwrapped(or: "Unknown error!!!")
        let nsError = NSError(domain: Bundle.main.bundleIdentifier.orEmpty, code: responseObj.errcode.unwrapped(or: 0), userInfo: [NSLocalizedDescriptionKey: errorMsg])
        return MoyaError.underlying(nsError, nil)
    }
}

extension Moya.Response {
    
    func mapStringValue() throws -> String {
        if var value = String(data: data, encoding: .utf8) {
            if value.hasSuffix("\n") { value = String(value.dropLast()) }
            if value.hasPrefix("\""), value.hasSuffix("\"") {
                value = String(value.dropFirst().dropLast())
                if value.isEmpty {
                    throw MoyaError.stringMapping(self)
                }
            }
            return value
        }
        throw MoyaError.stringMapping(self)
    }
}

extension APIRequest {
    
    @discardableResult
    private static func request<T: Decodable>(
        _ target: APIs,
        using decoder: JSONDecoder = JSONDecoder(),
        completion: @escaping (Swift.Result<T, Error>) -> Void
    ) -> Cancellable {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        return apiProvider.request(target) { result in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    do {
                        if let apiError: APIError = try? response.map(APIError.self) {
                            let error: NSError = NSError(code: response.statusCode, message: apiError.message)
                            completion(.failure(error))
                        } else {
                            let filteredResponse: Response = try response.filterSuccessfulStatusCodes()
                            let value: T = try filteredResponse.map(T.self, using: decoder, failsOnEmptyData: false)
                            completion(.success(value))
                        }
                    } catch let error {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    @discardableResult
    private static func request(
        _ target: APIs,
        completion: @escaping (Swift.Result<String, Error>) -> Void
    ) -> Cancellable {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        return apiProvider.request(target) { result in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    do {
                        if let apiError: APIError = try? response.map(APIError.self) {
                            let error: NSError = NSError(code: response.statusCode, message: apiError.message)
                            completion(.failure(error))
                        } else {
                            let filteredResponse: Response = try response.filterSuccessfulStatusCodes()
                            let value: String = try filteredResponse.mapStringValue()
                            completion(.success(value))
                        }
                    } catch let error {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

extension APIRequest {
    static func login(username: String, password: String, completion: @escaping (Swift.Result<String, Error>) -> Void) {
        APIRequest.request(.login(username: username, password: password), completion: completion)
    }
    
    static func register(customer: Customer, password: String, completion: @escaping (Result<Customer, Error>) -> Void) {
        APIRequest.request(.register(customer: customer, password: password), completion: completion)
    }
    
    static func getStore(id: String, completion: @escaping (Swift.Result<Store, Error>) -> Void) {
        APIRequest.request(.store(id: id), completion: completion)
    }
    
    static func fetchDashboard(completion: @escaping (Result<DashboardModel, Error>) -> Void) {
        APIRequest.request(.fetchDashboard, completion: completion)
    }

    static func getPaymentMethod(completion: @escaping (Result<String, Error>) -> Void) {
        APIRequest.request(.paymentMethod, completion: completion)
    }

    static func createACart(completion: @escaping (Result<String, Error>) -> Void) {
        APIRequest.request(.cartCreate, completion: completion)
    }

    static func getCartInfo(completion: @escaping (Result<CartDetail, Error>) -> Void) {
        APIRequest.request(.cartGetInfo, completion: completion)
    }

    static func addCartShippingAddress(shippingInfo: [String : Any], completion: @escaping (Result<String, Error>) -> Void) {
        APIRequest.request(.cartAddShippingAddress(shippingInfo: shippingInfo), completion: completion)
    }

    static func addAddProductToCart(productInfo: [String : Any], completion: @escaping (Result<String, Error>) -> Void) {
        APIRequest.request(.cartAddProduct(productInfo: productInfo), completion: completion)
    }

    static func getRemoveProductFromCart(productID: String, completion: @escaping (Result<String, Error>) -> Void) {
        APIRequest.request(.cartRemoveProduct(productID: productID), completion: completion)
    }

    static func oderCart(cartID: String, paymentMethod: [String: Any], completion: @escaping (Result<String, Error>) -> Void) {
        APIRequest.request(.cartOrder(cartID: cartID, paymentMethod: paymentMethod), completion: completion)
    }

    static func getCartShipMethod(cartID: String, completion: @escaping (Result<String, Error>) -> Void) {
        APIRequest.request(.cartShipMethod(cartID: cartID), completion: completion)
    }

    static func getCustomerToken(completion: @escaping (Result<String, Error>) -> Void) {
        APIRequest.request(.customerToken(userName: "dev+0@gmail.com", password: "Pass1234"), completion: completion)
    }
    
    static func search(keyword: String, completion: @escaping (Result<[ShopModel], Error>) -> Void) {
        APIRequest.request(.search(keyword: keyword), completion: completion)
    }

    static func orderACartDummyAPI(cartOrderParam: [String: Any], completion: @escaping (Result<String, Error>) -> Void) {
        APIRequest.request(.cartOrderDummyAPI(cartOrderParam: cartOrderParam), completion: completion)
    }
}
