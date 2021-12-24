//
//  Data+Ext.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. VN.Danang on 7/7/21.
//

import Foundation

extension Data {
    
    init(fromFile fileName: String) {
        guard let path: String = Bundle.main.path(forResource: fileName, ofType: "json") else {
            fatalError("Invalid path for file")
        }
        guard let data: Data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError("Invalid json file")
        }
        self = data
    }
}
