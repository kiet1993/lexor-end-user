//
//  TechnicianListServiceChildCell.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 7/11/21.
//

import UIKit

protocol TechnicianListServiceChildCellDelegate: AnyObject {
    func cell(_ cell: TechnicianListServiceChildCell, needPerformAction action: TechnicianListServiceChildCell.Action)
}

final class TechnicianListServiceChildCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var containerView: BorderView!
    @IBOutlet private var containerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var costLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var bookButton: UIButton!

    // MARK: - Properties
    enum Action {
        case bookService(atIndexPath: IndexPath)
    }

    weak var delegate: TechnicianListServiceChildCellDelegate?

    var viewModel: TechnicianListServiceChildCellModel? {
        didSet {
            updateUI()
        }
    }

    // MARK: - Life cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }

    // MARK: - Private
    private func configUI() {
        bookButton.cornerRadius = bookButton.bounds.height / 2
    }

    private func updateUI() {
        guard let viewModel = viewModel, let service = viewModel.serviceCellData?.serviceInfo else { return }
        var rectEdges: [UIRectEdge] = [.left, .right]
        if let isEndOfList = viewModel.serviceCellData?.isEndOfList, isEndOfList {
            containerViewBottomConstraint.constant = Config.bottomContant
            rectEdges.append(.bottom)
            containerView.addBorderClosure = {
                self.containerView.addBorder(edges: rectEdges, borderColor: UIColor.lightGray.withAlphaComponent(0.6), borderWidth: 1)
                self.containerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
            }
        } else {
            containerView.addBorderClosure = {
                self.containerView.addBorder(edges: rectEdges, borderColor: UIColor.lightGray.withAlphaComponent(0.6), borderWidth: 1)
                self.containerView.roundCorners(corners: [.allCorners], radius: 0)
            }
            containerViewBottomConstraint.constant = 0
        }

        nameLabel.text = service.name
        #warning("Update here when have final api")
        // ageLabel.text = String(format: Strings.ageRangeStr, String(service.), String(service.))
        costLabel.text = Supporter.shared.moneyFormatter.string(from: NSNumber(value: service.price))
        // timeLabel.text = String(format: Strings.minutes, String(service.time))
        layoutIfNeeded()
    }

    // MARK: - IBActions
    @IBAction private func bookButtonTouchUpInside(_ sender: UIButton) {
        guard let indexPath = viewModel?.indexPath else { return }
        delegate?.cell(self, needPerformAction: .bookService(atIndexPath: indexPath))
    }
}

// MARK: - Config
extension TechnicianListServiceChildCell {

    struct Strings {
        static let ageRangeStr: String = "Ages %@-%@"
        static let minutes: String = "%@ minutes"
    }

    struct Config {
        static let bottomContant: CGFloat = 10
    }
}
