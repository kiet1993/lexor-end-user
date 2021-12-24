//
//  NailItemCollectionViewCell.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/06/05.
//

import UIKit
import SDWebImage

class SmallTalkCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var descriptionImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.cornerRadius = avatarImageView.bounds.height / 2
        descriptionImageView.cornerRadius = 10
        containerView.cornerRadius = 10
        containerView.borderWidth = 0.5
        containerView.borderColor = .lightGray
    }

    func bind(model: SmallTalkModel) {
        nameLabel.text = model.name
        avatarImageView.sd_setImage(with: URL(string: model.avatar))
        descriptionImageView.sd_setImage(with: URL(string: model.image))
    }
}
