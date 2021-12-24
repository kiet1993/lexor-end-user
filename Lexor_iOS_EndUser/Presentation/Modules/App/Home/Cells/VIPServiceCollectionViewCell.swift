//
//  VIPServiceCollectionViewCell.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/07/15.
//

import UIKit

class VIPServiceCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var serviceNameLabel: UILabel!
    @IBOutlet private weak var salonNameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.cornerRadius = 10
        containerView.borderWidth = 0.5
        containerView.borderColor = .lightGray
    }

    func bind(product: ProductModel) {
        serviceNameLabel.text = product.name
        salonNameLabel.text = "Salon name"
        
        
        priceLabel.text = "$\(product.price)"
        timeLabel.text = " - 30 mins"
    }
}
