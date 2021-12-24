//
//  HotDealCollectionViewCell.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/07/15.
//

import UIKit

class HotDealCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.cornerRadius = 10
        containerView.borderWidth = 0.5
        containerView.borderColor = .lightGray
    }
    
    func bind(product: ProductModel) {
        nameLabel.text = product.name
        priceLabel.text = "$\(product.price)"
    }
}
