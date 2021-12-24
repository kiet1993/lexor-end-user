//
//  ConfirmBookingVC.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 6/3/21.
//

import UIKit

final class ConfirmBookingVC: BaseViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var bookButton: UIButton!

    @IBOutlet private weak var servicesContainerView: UIView!
    @IBOutlet private weak var servicesStackView: UIStackView!
    @IBOutlet private weak var totalTitleLabel: UILabel!
    @IBOutlet private weak var totalAmountLabel: UILabel!

    @IBOutlet private weak var giftCardLabel: UILabel!
    @IBOutlet private weak var giftDescriptionLabel: UILabel!
    @IBOutlet private weak var giftCardItemContainerView: UIView!
    @IBOutlet private weak var giftCardTitle: UILabel!
    @IBOutlet private weak var applyButton: UIButton!
    @IBOutlet private weak var giftCardExpireLabel: UILabel!
    @IBOutlet private weak var giftCardExpireDeadlineLabel: UILabel!
    @IBOutlet private weak var giftCardAmountTitleLabel: UILabel!
    @IBOutlet private weak var giftCardAmountLabel: UILabel!

    @IBOutlet private weak var serviceTotalAmountTitleLabel: UILabel!
    @IBOutlet private weak var serviceTotalAmountLabel: UILabel!
    @IBOutlet private weak var sumTotalAmountTitleLabel: UILabel!
    @IBOutlet private weak var sumTotalAmountLabel: UILabel!

    @IBOutlet private weak var eWalletContainerView: UIView!
    @IBOutlet private weak var eWalletCircleButton: UIButton!
    @IBOutlet private weak var eWalletTitleLabel: UILabel!
    @IBOutlet private weak var eWalletImageView: UIImageView!

    @IBOutlet private weak var cashSalonContainerView: UIView!
    @IBOutlet private weak var cashSalonCircleButton: UIButton!
    @IBOutlet private weak var cashSalonTitleLabel: UILabel!
    @IBOutlet private weak var cashSalonImageView: UIImageView!

    @IBOutlet private weak var fullNameContainerView: UIView!
    @IBOutlet private weak var fullNameTextfield: UITextField!
    @IBOutlet private weak var emailContainerView: UIView!
    @IBOutlet private weak var emailTextfield: UITextField!
    @IBOutlet private weak var phoneContainerView: UIView!
    @IBOutlet private weak var phoneTextfield: UITextField!
    @IBOutlet private weak var addressContainerView: UIView!
    @IBOutlet private weak var addressTextfield: UITextField!
    @IBOutlet private weak var cityContainerView: UIView!
    @IBOutlet private weak var cityTextfield: UITextField!
    @IBOutlet private weak var countryContainerView: UIView!
    @IBOutlet private weak var countryTextfield: UITextField!

    @IBOutlet private weak var creditDebitContainerView: UIView!
    @IBOutlet private weak var creditDebitCircleButton: UIButton!
    @IBOutlet private weak var creditDebitTitleLabel: UILabel!
    @IBOutlet private weak var creditDebitImageView: UIImageView!

    // MARK: - Properties
    var viewModel = ConfirmBookingVM(serviceBooked: [])

    private var paymentType: PaymentType = .cashSalon {
        didSet {
            updatedPaymentType()
        }
    }

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        updatedPaymentType()
        configServiceInfoView()
    }

    // MARK: - Private
    private func configUI() {
        title = Config.title
        bookButton.cornerRadius = bookButton.frame.height / 2
        servicesContainerView.cornerRadius = Config.corner
        servicesContainerView.borderWidth = Config.borderWidth
        servicesContainerView.borderColor = Config.gray155

        applyButton.cornerRadius = applyButton.frame.height / 2
        applyButton.borderWidth = Config.borderWidth
        applyButton.borderColor = Config.gray155
        giftCardItemContainerView.cornerRadius = Config.corner
        giftCardItemContainerView.borderWidth = Config.borderWidth
        giftCardItemContainerView.borderColor = Config.gray155

        eWalletCircleButton.setImage(Config.selectedPayTypeImage, for: .selected)
        eWalletCircleButton.setImage(Config.unSelectPayTypeImage, for: .normal)
        cashSalonCircleButton.setImage(Config.selectedPayTypeImage, for: .selected)
        cashSalonCircleButton.setImage(Config.unSelectPayTypeImage, for: .normal)

        fullNameContainerView.cornerRadius = fullNameContainerView.bounds.height / 2
        fullNameContainerView.borderColor = Config.gray155
        fullNameContainerView.borderWidth = Config.borderWidth
        fullNameTextfield.delegate = self
        emailContainerView.cornerRadius = emailContainerView.bounds.height / 2
        emailContainerView.borderColor = Config.gray155
        emailContainerView.borderWidth = Config.borderWidth
        emailTextfield.delegate = self
        phoneContainerView.cornerRadius = phoneContainerView.bounds.height / 2
        phoneContainerView.borderColor = Config.gray155
        phoneContainerView.borderWidth = Config.borderWidth
        phoneTextfield.delegate = self
        addressContainerView.cornerRadius = addressContainerView.bounds.height / 2
        addressContainerView.borderColor = Config.gray155
        addressContainerView.borderWidth = Config.borderWidth
        addressTextfield.delegate = self
        cityContainerView.cornerRadius = cityContainerView.bounds.height / 2
        cityContainerView.borderColor = Config.gray155
        cityContainerView.borderWidth = Config.borderWidth
        cityTextfield.delegate = self
        countryContainerView.cornerRadius = countryContainerView.bounds.height / 2
        countryContainerView.borderColor = Config.gray155
        countryContainerView.borderWidth = Config.borderWidth
        countryTextfield.delegate = self

        creditDebitCircleButton.setImage(Config.selectedPayTypeImage, for: .selected)
        creditDebitCircleButton.setImage(Config.unSelectPayTypeImage, for: .normal)
    }

    private func updatedPaymentType() {
        eWalletContainerView.alpha = paymentType == .eWallet ? 1 : 0.5
        eWalletCircleButton.isSelected = paymentType == .eWallet

        cashSalonContainerView.alpha = paymentType == .cashSalon ? 1 : 0.5
        cashSalonCircleButton.isSelected = paymentType == .cashSalon

        creditDebitContainerView.alpha = paymentType == .creditDebit ? 1 : 0.5
        creditDebitCircleButton.isSelected = paymentType == .creditDebit
    }

    private func configServiceInfoView() {
        servicesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for data in viewModel.serviceBooked.enumerated() {
            let serviceView: ServiceInfoView = ServiceInfoView.loadNib()
            serviceView.viewModel = ServiceInfoViewModel(serviceInfo: data.element,
                                                         isShowWaitButton: viewModel.serviceBooked.count > 1 && data.offset < viewModel.serviceBooked.count - 1,
                                                         isCanDelete: viewModel.serviceBooked.count > 1)
            serviceView.delegate = self
            servicesStackView.addArrangedSubview(serviceView)
        }
        totalAmountLabel.text = viewModel.totalAmount
        servicesStackView.layoutIfNeeded()
    }

    private func orderCart() {
        HUD.show()
        viewModel.orderCart() { [weak self] result in
            HUD.popActivity()
            guard let this = self else { return }
            switch result {
            case .success(let orderID):
                let message = String(format: Config.success, orderID)
                this.showAlert(title: "", message: message, handler:  {
                    this.navigationController?.popToRootViewController(animated: true)
                })
            case .failure(let error):
                this.showAlert(title: "", message: error.localizedDescription)
            }
        }
    }

    private func getExitsCart() {
        HUD.show()
        viewModel.getExitsCart { [weak self] result in
            HUD.popActivity()
            guard let this = self else { return }
            switch result {
            case .success:
                this.getPaymentMethod()
            case .failure(let error):
                this.showAlert(title: "", message: error.localizedDescription)
            }
        }
    }

    private func getPaymentMethod() {
        HUD.show()
        viewModel.getPaymentMethod { [weak self] result in
            HUD.popActivity()
            guard let this = self else { return }
            switch result {
            case .success:
                this.orderCart()
            case .failure(let error):
                this.showAlert(title: "", message: error.localizedDescription)
            }
        }
    }

    // MARK: - IBActions
    @IBAction private func bookButtonTouchUpInside(_ sender: Any) {
        showAlert(title: "", message: Config.confirmAlertTitle, buttonTitles: [Config.ok, Config.cancel], completion: { [weak self] buttonIndex in
            guard let this = self else { return }
            switch buttonIndex {
            case 0:
                this.getExitsCart()
            default:
                break
            }
        })
    }

    @IBAction private func applyButtonTouchUpInside(_ sender: Any) {
    }

    @IBAction private func paymentTypeButtonTouchUpInside(_ sender: UIButton) {
        switch sender {
        case eWalletCircleButton:
            guard paymentType != .eWallet else { return }
            paymentType = .eWallet
        case cashSalonCircleButton:
            guard paymentType != .cashSalon else { return }
            paymentType = .cashSalon
        case creditDebitCircleButton:
            guard paymentType != .creditDebit else { return }
            paymentType = .creditDebit
        default:
            break
        }
    }
}

// MARK: - UITextFieldDelegate
extension ConfirmBookingVC: UITextFieldDelegate {
}

// MARK: - ServiceInfoViewDelegate
extension ConfirmBookingVC: ServiceInfoViewDelegate {

    func view(_ view: ServiceInfoView, needPerformAction action: ServiceInfoView.Action) {
        switch action {
        case .deleteService(let nameService):
            HUD.show()
            viewModel.removeService(withName: nameService) { [weak self] result in
                HUD.popActivity()
                guard let this = self else { return }
                switch result {
                case .success:
                    this.configServiceInfoView()
                case .failure(let error):
                    this.showAlert(title: "", message: error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - Config
extension ConfirmBookingVC {

    enum PaymentType: Int, CaseIterable {
        case eWallet
        case cashSalon
        case creditDebit
    }

    struct Config {
        static let title: String = "Payment"
        static let success: String = "Book successfully with orderID: %@"
        static let confirmAlertTitle: String = "Are you sure?"
        static let ok: String = "OK"
        static let cancel: String = "Cancel"
        static let corner: CGFloat = 12
        static let borderWidth: CGFloat = 2
        static let gray155: UIColor = UIColor(red: 155, green: 155, blue: 155)
        static let selectedPayTypeImage: UIImage? = UIImage(named: "ic_common_circle_checkmark")
        static let unSelectPayTypeImage: UIImage? = UIImage(named: "ic_common_circle")
    }
}
