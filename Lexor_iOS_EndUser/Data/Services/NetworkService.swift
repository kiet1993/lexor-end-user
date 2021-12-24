//
//  NetworkService.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/10/12.
//

import Moya

protocol NetworkServiceType {
    typealias CompletionHandler<T> = (Result<T, Error>) -> Void
    func searchShopName(keyword: String, completion: @escaping CompletionHandler<BaseResponseModel<ShopItemModel>>)
    func login(username: String, password: String, completion: @escaping CompletionHandler<String>)
    func register(customer: Customer, password: String, completion: @escaping CompletionHandler<Customer>)
    func fetchHotDeals(currentPage: Int, pageSize: Int, completion: @escaping CompletionHandler<BaseResponseModel<ProductModel>>)
    func fetchVipServices(currentPage: Int, pageSize: Int, completion: @escaping CompletionHandler<BaseResponseModel<ProductModel>>)
    func getStore(id: String, completion: @escaping CompletionHandler<Store>)
    func getStoreServices(id: String, currentPage: Int, completion: @escaping CompletionHandler<BaseResponseModel<Service>>)
    func getStoreReviews(id: String, currentPage: Int, completion: @escaping CompletionHandler<BaseResponseModel<Review>>)
    func getStoreHotDeals(id: String, completion: @escaping CompletionHandler<BaseResponseModel<Service>>)
    func getStoreTechnicians(id: String, completion: @escaping CompletionHandler<[Technician]>)
}

final class NetworkService {
    static let shared = NetworkService()
    
    private lazy var configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 30
        return config
    }()
    
    private lazy var session: Session = {
        return Session(configuration: configuration,
                       serverTrustManager: SSLServerTrustManager())
    }()
    
    
    private lazy var provider = MoyaProvider<APITarget>(
        session: session,
        plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: [.requestMethod,
                                                                        .requestHeaders,
                                                                        .requestBody,
//                                                                        .formatRequestAscURL,
                                                                        .successResponseBody,
                                                                        .errorResponseBody]))]
    )
    
    @discardableResult
    func request<T: Decodable>(target: APITarget, using decoder: JSONDecoder = JSONDecoder(), completion: @escaping CompletionHandler<T>) -> Cancellable {
        let task = provider.request(target) { result in
            switch result {
            case .success(let response):
                self.handleResponse(response, using: decoder, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
}

extension NetworkService {
    private func handleResponse<T: Decodable>(
        _ response: Moya.Response,
        using decoder: JSONDecoder = JSONDecoder(),
        completion: @escaping CompletionHandler<T>
    ){
        if let apiError: APIError = try? response.map(APIError.self) {
            let error: NSError = NSError(code: response.statusCode, message: apiError.message)
            return completion(.failure(error))
        }
        switch response.statusCode {
        case 200...299:
            do {
                let model = try response.map(T.self, using: decoder)
                completion(.success(model))
            } catch {
                completion(.failure(error))
            }
        default:
            completion(.failure(NetworkError.unknown))
        }
    }
}


extension NetworkService: NetworkServiceType {
    func fetchVipServices(currentPage: Int,
                          pageSize: Int,
                          completion: @escaping CompletionHandler<BaseResponseModel<ProductModel>>) {
        request(target: .fetchVipServices(currentPage: currentPage, pageSize: pageSize), completion: completion)
    }
    
    func fetchHotDeals(currentPage: Int, pageSize: Int, completion: @escaping CompletionHandler<BaseResponseModel<ProductModel>>) {
        request(target: .fetchHotDeals(currentPage: currentPage, pageSize: pageSize), completion: completion)
    }
    
    func searchShopName(keyword: String, completion: @escaping CompletionHandler<BaseResponseModel<ShopItemModel>>) {
        request(target: .searchShopName(keyword: keyword), completion: completion)
    }
    
    func login(username: String, password: String, completion: @escaping CompletionHandler<String>) {
        request(target: .login(username: username, password: password), completion: completion)
    }

    func createEmptyCart(completion: @escaping CompletionHandler<Int>) {
        request(target: .cartCreate, completion: completion)
    }

    func getCartInfo(completion: @escaping CompletionHandler<CartOrderResult>) {
        request(target: .cartGetInfo, completion: completion)
    }

    func addAddProductToCart(productInfo: [String : Any], completion: @escaping CompletionHandler<CartAddProductResult>) {
        request(target: .cartAddProduct(productInfo: productInfo), completion: completion)
    }

    func getPaymentMethod(completion: @escaping CompletionHandler<CartOderPaymentMethodResult>) {
        request(target: .paymentMethod, completion: completion)
    }

    func bookingOrder(orderInfo: [String: Any], completion: @escaping CompletionHandler<String>) {
        request(target: .cartBookingOrder(orderInfo: orderInfo), completion: completion)
    }
    
    func register(customer: Customer, password: String, completion: @escaping CompletionHandler<Customer>) {
        request(target: .register(customer: customer, password: password), completion: completion)
    }
    
    func getStore(id: String, completion: @escaping CompletionHandler<Store>) {
        request(target: .store(id: id), completion: completion)
    }
    
    func getStoreServices(id: String, currentPage: Int, completion: @escaping CompletionHandler<BaseResponseModel<Service>>) {
        request(target: .getStoreServices(id: id, currentPage: currentPage), using: JSONDecoder.customUTC(withFormat: .dateTime), completion: completion)
    }
    
    func getStoreReviews(id: String, currentPage: Int, completion: @escaping CompletionHandler<BaseResponseModel<Review>>) {
        request(target: .getStoreReviews(id: id, currentPage: currentPage), using: JSONDecoder.customUTC(withFormat: .dateTime), completion: completion)
    }
    
    func getStoreHotDeals(id: String, completion: @escaping CompletionHandler<BaseResponseModel<Service>>) {
        request(target: .getStoreHotDeals(id: id), using: JSONDecoder.customUTC(withFormat: .dateTime), completion: completion)
    }
    
    func getStoreTechnicians(id: String, completion: @escaping CompletionHandler<[Technician]>) {
        request(target: .getStoreTechnicians(id: id), completion: completion)
    }
    
    func fetchTechnicians(currentPage: Int,
                          pageSize: Int,
                          completion: @escaping CompletionHandler<BaseResponseModel<BestNailArtistModel>>) {
        request(target: .fetchTechnicians(currentPage: currentPage, pageSize: pageSize), completion: completion)
    }
}
