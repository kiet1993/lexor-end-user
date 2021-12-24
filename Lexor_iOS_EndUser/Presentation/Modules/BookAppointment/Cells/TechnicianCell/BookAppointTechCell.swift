//
//  BookAppointTechCell.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 6/8/21.
//

import UIKit
import SDWebImage

final class BookAppointTechCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var avataImageView: UIImageView!
    @IBOutlet private weak var selectedImageView: UIImageView!
    @IBOutlet private weak var avataContainerView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!

    // MARK: - Properties
    var viewModel: BookAppointTechCellModel? {
        didSet {
            updateView()
        }
    }

    // MARK: - Life cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }

    // MARK: - Private
    private func configUI() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.avataContainerView.cornerRadius = self.avataContainerView.bounds.height / 2
        })
        avataContainerView.borderColor = Config.borderColor
        avataContainerView.borderWidth = Config.borderWidth
        selectedImageView.image = UIImage(named: "ic_common_circle_checkmark")
        selectedImageView.cornerRadius = selectedImageView.bounds.height / 2
        selectedImageView.isHidden = true
    }

    private func updateView() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.name
        // avataImageView.sd_setImage(with: URL(string: viewModel.imageURL))
        selectedImageView.isHidden = !viewModel.isSelected
    }
}

// MARK: - Config
extension BookAppointTechCell {

    struct Config {
        static let borderWidth: CGFloat = 1
        static let borderColor: UIColor = UIColor(red: 155, green: 155, blue: 155)
    }
}
