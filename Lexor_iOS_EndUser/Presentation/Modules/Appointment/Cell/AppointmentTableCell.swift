//
//  AppointmentTableCell.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 7/4/21.
//

import UIKit

protocol AppointmentTableCellDelegate: AnyObject {
    func cell(_ cell: AppointmentTableCell, needPerformAction action: AppointmentTableCell.Action)
}

final class AppointmentTableCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var avataImageView: UIImageView!
    @IBOutlet private weak var shopTitleLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var favouriteButton: UIButton!
    @IBOutlet private weak var serviceTitleLabel: UILabel!
    @IBOutlet private weak var serviceCostLabel: UILabel!

    @IBOutlet private weak var technicianParentStackView: UIStackView!
    @IBOutlet private weak var technicianTitleLabel: UILabel!
    @IBOutlet private weak var technicianTimeLabel: UILabel!

    @IBOutlet private weak var designParentStackView: UIStackView!
    @IBOutlet private weak var designTitleLabel: UILabel!
    @IBOutlet private weak var designTimeLabel: UILabel!

    @IBOutlet private weak var feeParentStackView: UIStackView!
    @IBOutlet private weak var feeTitleLabel: UILabel!
    @IBOutlet private weak var feeValueLabel: UILabel!

    @IBOutlet private weak var bookingDateParentStackView: UIStackView!
    @IBOutlet private weak var bookingDateTitleLabel: UILabel!
    @IBOutlet private weak var bookingDateValueLabel: UILabel!

    @IBOutlet private weak var leftActionButton: UIButton!
    @IBOutlet private weak var rightActionButton: UIButton!

    // MARK: - Properties
    enum Action {
        case touchFavourite(_ indexPath: IndexPath)
        case review(_ indexPath: IndexPath)
        case rebook(_ indexPath: IndexPath)
        case edit(_ indexPath: IndexPath)
        case cancel(_ indexPath: IndexPath)
    }

    weak var delegate: AppointmentTableCellDelegate?

    var viewModel: AppointmentTableCellModel? {
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
        containerView.borderWidth = 1
        containerView.borderColor = UIColor.lightGray.withAlphaComponent(0.6)
        containerView.addShadow(ofColor: .black, radius: 5, offset: CGSize(width: 1, height: 1), opacity: 0.1)

        leftActionButton.cornerRadius = leftActionButton.bounds.height / 2
        leftActionButton.borderWidth = 1
        leftActionButton.borderColor = UIColor.lightGray.withAlphaComponent(0.6)
        rightActionButton.cornerRadius = rightActionButton.bounds.height / 2

        favouriteButton.setImage(UIImage(named: "ic-heart"), for: .normal)
        favouriteButton.setImage(UIImage(named: "ic-heart.fill"), for: .selected)
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        switch viewModel.screenType {
        case .upComming:
            rightActionButton.setTitle(Config.editTitle, for: .normal)
            leftActionButton.setTitle(Config.cancelTitle, for: .normal)
        case .past:
            rightActionButton.setTitle(Config.rebookTitle, for: .normal)
            leftActionButton.setTitle(Config.reviewTitle, for: .normal)
        }
        avataImageView.image = UIImage(named: viewModel.appointmentData.imageName)
        shopTitleLabel.text = viewModel.appointmentData.salonName
        addressLabel.text = viewModel.appointmentData.address
        favouriteButton.isSelected = viewModel.appointmentData.isFavorite
        serviceTitleLabel.text = viewModel.appointmentData.serviceName
        serviceCostLabel.text = Supporter.shared.moneyFormatter.string(from: NSNumber(value: viewModel.appointmentData.serviceCost))

        technicianTitleLabel.text = String(format: Config.technicianTitle, viewModel.appointmentData.technician)
        technicianTimeLabel.text = viewModel.appointmentData.technicianSchedule
        technicianParentStackView.isHidden = viewModel.appointmentData.technicianSchedule.isEmpty

        designTitleLabel.text =  String(format: Config.designTitle, viewModel.appointmentData.design)
        designTimeLabel.text = viewModel.appointmentData.designSchedule
        designParentStackView.isHidden = viewModel.appointmentData.designSchedule.isEmpty

        feeTitleLabel.text =  Config.feeTitle
        feeValueLabel.text = Supporter.shared.moneyFormatter.string(from: NSNumber(value: viewModel.appointmentData.fee))
        feeParentStackView.isHidden = false

        bookingDateTitleLabel.text =  Config.bookingDateTitle
        bookingDateValueLabel.text = viewModel.appointmentData.bookingDate
        bookingDateParentStackView.isHidden = viewModel.appointmentData.bookingDate.isEmpty
    }

    // MARK: - IBActions
    @IBAction private func favoriteButtonTouchUpInside(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, needPerformAction: .touchFavourite(viewModel.indexPath))
    }

    @IBAction private func leftActionButtonTouchUpInside(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        switch viewModel.screenType {
        case .upComming:
            delegate?.cell(self, needPerformAction: .cancel(viewModel.indexPath))
        case .past:
            delegate?.cell(self, needPerformAction: .review(viewModel.indexPath))
        }
    }

    @IBAction private func rightActionButtonTouchUpInside(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        switch viewModel.screenType {
        case .upComming:
            delegate?.cell(self, needPerformAction: .edit(viewModel.indexPath))
        case .past:
            delegate?.cell(self, needPerformAction: .rebook(viewModel.indexPath))
        }
    }
}

// MARK: - Config
extension AppointmentTableCell {

    struct Config {
        static let reviewTitle: String = "Review"
        static let rebookTitle: String = "Rebook"
        static let cancelTitle: String = "Cancel"
        static let editTitle: String = "Edit"
        static let technicianTitle: String = "Technician: %@"
        static let designTitle: String = "Design: %@"
        static let feeTitle: String = "Fee"
        static let bookingDateTitle: String = "Booking date"
    }
}
