//
//  TechnicianListCell.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 7/11/21.
//

import UIKit
import SDWebImage

protocol TechnicianListCellDelegate: AnyObject {
    func cell(_ cell: TechnicianListCell, needPerformAction action: TechnicianListCell.Action)
}

final class TechnicianListCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var containerView: BorderView!
    @IBOutlet private var containerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var avataImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!

    // MARK: - Properties
    enum Action {
        case didTapFavorite(IndexPath)
    }

    var viewModel: TechnicianListCellModel? {
        didSet {
            updateView()
        }
    }

    weak var delegate: TechnicianListCellDelegate?

    // MARK: - Life cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }

    // MARK: - Private
    private func configUI() {
        avataImageView.cornerRadius = avataImageView.bounds.height / 2

        favoriteButton.setImage(UIImage(named: "ic-heart"), for: .normal)
        favoriteButton.setImage(UIImage(named: "ic-heart.fill"), for: .selected)
        /*
        containerView.addBorderClosure = {
            self.containerView.addBorder(edges: [.left, .top, .right], borderColor:  UIColor.lightGray.withAlphaComponent(0.6), borderWidth: 1)
            self.containerView.roundCorners(corners: [.allCorners], radius: 10)
            self.layoutIfNeeded()
        }
         */
    }

    private func updateView() {
        guard let viewModel = viewModel else { return }
        if let imageURL = URL(string: (viewModel.technicianData?.avatarURL).unwrapped(or: "")) {
            avataImageView.sd_setImage(with: imageURL)
        }
        nameLabel.text = viewModel.technicianData?.name
        favoriteButton.isSelected = (viewModel.technicianData?.isFavorite).unwrapped(or: false)
        if viewModel.isNoService {
            containerView.layer.cornerRadius = 10
            containerView.borderWidth = 1
            containerView.borderColor = UIColor.lightGray.withAlphaComponent(0.6)
            //containerView.addBorder(edges: [.all], borderColor:  UIColor.lightGray.withAlphaComponent(0.6), borderWidth: 1)
            containerViewBottomConstraint.constant = 10
        } else {
            containerViewBottomConstraint.constant = 0
        }
        layoutIfNeeded()
    }

    // MARK: - IBActions
    @IBAction private func favoriteButtonTouchUpInside(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, needPerformAction: .didTapFavorite(viewModel.indexPath))
    }
}
