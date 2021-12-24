//
//  SearchResultImageCollectionViewCell.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/06/15.
//

import UIKit

class SearchResultImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    
    func bind(url:  String) {
        imageView.sd_setImage(with: URL(string: url))
    }
}
