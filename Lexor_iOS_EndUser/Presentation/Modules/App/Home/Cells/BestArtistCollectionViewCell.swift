//
//  BestArtistCollectionViewCell.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/07/15.
//

import UIKit
import Cosmos
import SDWebImage

class BestArtistCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var ratingView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.cornerRadius = imageView.bounds.height / 2
        containerView.cornerRadius = 10
        containerView.borderWidth = 0.5
        containerView.borderColor = .lightGray

    }
    
    func bind(model: BestNailArtistModel) {
        let url = ImageURLConstants.technician(model.mediaPath).url
        imageView.setImageWith(url)
        nameLabel.text = model.name
        descriptionLabel.text = model.description
        
        ratingView.rating = Double(model.extensionAttributes.ratingSummary / 20)
    }
}
