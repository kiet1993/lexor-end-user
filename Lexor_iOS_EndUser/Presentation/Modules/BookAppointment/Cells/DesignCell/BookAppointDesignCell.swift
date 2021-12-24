//
//  BookAppointDesignCell.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 6/8/21.
//

import UIKit

final class BookAppointDesignCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var designView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var selectedImageView: UIImageView!

    // MARK: - Properties
    var viewModel: BookAppointDesignCellModel? {
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
        designView.cornerRadius = Config.corner
        designView.borderColor = Config.borderColor
        designView.borderWidth = Config.borderWidth
        selectedImageView.image = UIImage(named: "ic_common_circle_checkmark")
        selectedImageView.cornerRadius = selectedImageView.bounds.height / 2
    }

    private func updateView() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.name
        designView.backgroundColor = UIColor(hexString: viewModel.colorHex)
        selectedImageView.isHidden = !viewModel.isSelected
    }
}

// MARK: - Config
extension BookAppointDesignCell {

    struct Config {
        static let corner: CGFloat = 10
        static let borderWidth: CGFloat = 2
        static let borderColor: UIColor = UIColor(red: 155, green: 155, blue: 155)
    }
}
