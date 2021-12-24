//
//  MoreTableCell.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 7/7/21.
//

import UIKit

final class MoreTableCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var leftImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Properties
    var viewModel: MoreTableCellModel? {
        didSet {
            updateUI()
        }
    }

    // MARK: - Life cycles
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Private
    private func updateUI() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.type.title
        leftImageView.image = viewModel.type.image
    }
}
