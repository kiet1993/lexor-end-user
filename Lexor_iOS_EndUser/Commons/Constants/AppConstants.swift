//
//  AppConstants.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/10/24.
//

import Foundation
enum ImageURLConstants {
    case technician(_ name: String)
    
    var url: URL? {
        switch self {
        case .technician(let name):
            let url = "https://salon360.bavaan.com/media/retailertechnician/" + name
            return try? url.asURL()
        }
    }
}
