//
//  APIResponse+Error.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. VN.Danang on 7/6/21.
//

import Foundation
import Moya

extension MoyaError {
    var underlyingError: Error {
        switch self {
        case .encodableMapping: return self
        case .imageMapping: return self
        case .jsonMapping: return self
        case .objectMapping: return self
        case .parameterEncoding: return self
        case .requestMapping: return self
        case .statusCode: return self
        case .stringMapping: return self
        case .underlying(let error, _): return error
        }
    }
}

protocol NetworkResponseErrorCodeType {
    var errcode: Int? { get }
}

class ResponseVoid: Decodable, NetworkResponseErrorCodeType {
    var message: String?
    var errcode: Int?
    var status: Int?
    var dataError: DataError?

    enum CodingKeys: String, CodingKey {
        case errcode, message, status
        case dataError = "data-error"
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        errcode = try container.decodeIfPresent(Int.self, forKey: .errcode)
        status = try container.decodeIfPresent(Int.self, forKey: .status)
        dataError = try container.decodeIfPresent(DataError.self, forKey: .dataError)
    }
}

class DataError: Codable { }

class AppResponse<Result: Decodable>: ResponseVoid {
    let data: Result?

    private enum CodingKeys: String, CodingKey {
        case data
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decodeIfPresent(Result.self, forKey: .data)
        try super.init(from: decoder)
    }
}

struct EmptyResponse: Decodable { }

struct APIError: Decodable {
    
    let message: String
}
