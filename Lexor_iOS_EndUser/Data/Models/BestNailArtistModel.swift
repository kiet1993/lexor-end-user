//
//  BestNailArtistModel.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/10/23.
//

import Foundation

// MARK: - BestNailArtistModel
struct BestNailArtistModel: Codable {
    let id: Int
    let name, description: String
    let status: Int
    let mediaPath: String
    let retailerID, price, sort: Int
    let extensionAttributes: ExtensionAttributes

    enum CodingKeys: String, CodingKey {
        case id, name
        case description = "description"
        case status
        case mediaPath = "media_path"
        case retailerID = "retailer_id"
        case price, sort
        case extensionAttributes = "extension_attributes"
    }
    
    
    // MARK: - ExtensionAttributes
    struct ExtensionAttributes: Codable {
        let ratingSummary: Int

        enum CodingKeys: String, CodingKey {
            case ratingSummary = "rating_summary"
        }
    }
}

