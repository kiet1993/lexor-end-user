//
//  ServiceInfoView.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 6/7/21.
//

import UIKit

protocol ServiceInfoViewDelegate: AnyObject {
    func view(_ view: ServiceInfoView, needPerformAction action: ServiceInfoView.Action)
}

final class ServiceInfoView: UIView {

    // MARK: - IBOutlets
    @IBOutlet private weak var serviceTitleLabel: UILabel!
    @IBOutlet private weak var serviceCostLabel: UILabel!
    @IBOutlet private weak var technicianLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var designLabel: UILabel!
    @IBOutlet private weak var designTimeLabel: UILabel!

    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var waitTimeButton: UIButton!

    // MARK: - Properties
    var viewModel: ServiceInfoViewModel? {
        didSet {
            updateUI()
        }
    }

    enum Action {
        case deleteService(_ name: String)
    }

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter
    }()

    weak var delegate: ServiceInfoViewDelegate?

    // MARK: - Life cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }

    // MARK: - Private
    private func configUI() {
        cancelButton.isHidden = true
        waitTimeButton.isHidden = true
        waitTimeButton.isUserInteractionEnabled = false
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        serviceTitleLabel.text = viewModel.serviceInfo.name
        serviceCostLabel.text = "$\(viewModel.serviceInfo.price)"
        #warning("Update later when have finally api")
        technicianLabel.text = String(format: Config.textTechnician, "\(viewModel.serviceInfo.price)")
        timeLabel.text = viewModel.serviceInfo.sku
        designLabel.text = String(format: Config.textDesign, viewModel.serviceInfo.sku)
        designTimeLabel.text = dateFormatter.string(from: viewModel.serviceInfo.updatedDate.unwrapped(or: Date()))
        cancelButton.isHidden = !viewModel.isCanDelete
        waitTimeButton.isHidden = !viewModel.isShowWaitButton
    }

    // MARK: - Public

    // MARK: - IBActions
    @IBAction private func cancelButtonTouchUpInside(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        delegate?.view(self, needPerformAction: .deleteService(viewModel.serviceInfo.name))
    }
}

// MARK: - Config
extension ServiceInfoView {
    struct Config {
        static let textTechnician: String = "Technician: %@"
        static let textDesign: String = "Design: %@"
    }
}
