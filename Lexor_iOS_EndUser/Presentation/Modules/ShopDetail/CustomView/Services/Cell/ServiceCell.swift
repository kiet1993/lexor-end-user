//
//  ServiceCell.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. VN.Danang on 6/3/21.
//

import UIKit

protocol ServiceCellDelegate: AnyObject {
    func cell(_ cell: ServiceCell, needPerformAction action: ServiceCell.Action)
}

final class ServiceCell: UITableViewCell {
    
    enum Action {
        case bookItem(_ service: Service)
    }
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var agesLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var dealLabel: UILabel!
    
    var viewModel: ServiceCellViewModel? {
        didSet {
            update()
        }
    }
    
    weak var delegate: ServiceCellDelegate?
    
    private func update() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.name
        agesLabel.text = viewModel.ages
        priceLabel.text = viewModel.price
        timeLabel.text = viewModel.time
        dealLabel.text = viewModel.deal
    }
    
    @IBAction private func bookButtonTouchUpInside(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, needPerformAction: .bookItem(viewModel.service))
    }
}
