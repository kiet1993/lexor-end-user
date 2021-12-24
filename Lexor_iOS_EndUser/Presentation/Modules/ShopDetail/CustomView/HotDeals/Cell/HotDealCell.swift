//
//  HotDealCell.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. VN.Danang on 7/2/21.
//

import UIKit

protocol HotDealCellDelegate: AnyObject {
    func cell(_ cell: HotDealCell, needsPerform action: HotDealCell.Action)
}

final class HotDealCell: UICollectionViewCell {
    
    enum Action {
        case order(_ service: Service)
    }
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dealLabel: UILabel!
    
    var viewModel: HotDealCellViewModel? {
        didSet {
            update()
        }
    }
    
    weak var delegate: HotDealCellDelegate?
    
    private func update() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.name
        setAttributesForDeal(with: viewModel.price)
    }
    
    private func setAttributesForDeal(with string: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        dealLabel.attributedText = NSMutableAttributedString(string: string, attributes: attributes)
    }
    
    @IBAction private func orderButtonTouchUpInside(_ sender: UIButton) {
        guard let viewModel = viewModel, let delegate = delegate else { return }
        delegate.cell(self, needsPerform: .order(viewModel.service))
    }
}
