//
//  SSLServerTrustManager.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/10/14.
//

import Alamofire

class SSLServerTrustManager : ServerTrustManager {
    override func serverTrustEvaluator(forHost host: String) throws -> ServerTrustEvaluating? {
        return DisabledTrustEvaluator()
    }

    init() {
        super.init(evaluators: [:])
    }
}
