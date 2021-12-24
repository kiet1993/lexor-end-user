//
//  ImageCollectionViewCell.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/07/26.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(url: String) {
        imageView.sd_setImage(with: URL(string: url))
    }
}
