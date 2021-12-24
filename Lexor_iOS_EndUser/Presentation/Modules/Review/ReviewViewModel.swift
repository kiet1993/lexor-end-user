//
//  ReviewViewModel.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. VN.Danang on 7/4/21.
//

import UIKit

final class ReviewViewModel {
    
    let shopName: String
    var imagesDidChangeHandler: (() -> Void)?
    var images: [UIImage] = [] {
        didSet {
            imagesDidChangeHandler?()
        }
    }
    
    init(shopName: String) {
        self.shopName = shopName
    }
    
    func removeImages(at index: Int) {
        if images.indices.contains(index - 1) {
            images.remove(at: index - 1)
        }
    }
}
