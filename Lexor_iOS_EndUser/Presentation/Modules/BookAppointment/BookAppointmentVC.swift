//
//  BookAppointmentVC.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 6/7/21.
//

import UIKit

final class BookAppointmentVC: BaseViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var servicesContainerView: UIView!
    @IBOutlet private weak var servicesStackView: UIStackView!
    @IBOutlet private weak var totalTitleLabel: UILabel!
    @IBOutlet private weak var totalAmountLabel: UILabel!

    @IBOutlet private weak var designInfoContainerView: UIView!
    @IBOutlet private weak var designAvailableTitle: UILabel!
    @IBOutlet private weak var useYourDesignButton: UIButton!
    @IBOutlet private weak var designCollectionView: UICollectionView!
    @IBOutlet private weak var designCollectionViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet private weak var technicianContainerView: UIView!
    @IBOutlet private weak var technicianTitleLabel: UILabel!
    @IBOutlet private weak var selectTechnicianButton: UIButton!
    @IBOutlet private weak var technicianCollectionView: UICollectionView!
    @IBOutlet private weak var technicianCollectionViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet private weak var appointmentDateButton: UIButton!

    @IBOutlet private weak var noteContainerView: UIView!
    @IBOutlet private weak var noteTextField: UITextField!

    @IBOutlet private weak var addServiceButton: UIButton!
    @IBOutlet private weak var confirmButton: UIButton!

    // MARK: - Properties
    var viewModel: BookAppointmentVM = BookAppointmentVM(serviceSelectedInfoList: [])
    private var serviceInfoList: [Service] = []

    private let dateTextField = UITextField()
    private let datePicker = UIDatePicker()

    private lazy var designCollectionCellSize: CGSize = {
        CGSize(width: designCollectionView.bounds.width / 5 - Config.cellSpacing / 3, height: designCollectionView.bounds.height)
    }()

    private lazy var technicianCollectionCellSize: CGSize = {
        CGSize(width: technicianCollectionView.bounds.width / 5 - Config.cellSpacing / 3, height: technicianCollectionView.bounds.height)
    }()

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configCollectionViews()
        configDatePicker()
        createCart()
    }

    // MARK: - Private
    private func configUI() {
        title = Config.title

        servicesContainerView.cornerRadius = Config.corner
        servicesContainerView.borderColor = Config.gray155
        servicesContainerView.borderWidth = Config.borderWidth
        totalTitleLabel.text = Config.total

        designInfoContainerView.cornerRadius = Config.corner
        designInfoContainerView.borderColor = Config.gray155
        designInfoContainerView.borderWidth = Config.borderWidth
        useYourDesignButton.borderColor = Config.gray155
        useYourDesignButton.borderWidth = Config.borderWidth
        useYourDesignButton.cornerRadius = useYourDesignButton.bounds.height / 2

        technicianContainerView.cornerRadius = Config.corner
        technicianContainerView.borderColor = Config.gray155
        technicianContainerView.borderWidth = Config.borderWidth
        selectTechnicianButton.borderColor = Config.gray155
        selectTechnicianButton.borderWidth = Config.borderWidth
        selectTechnicianButton.cornerRadius = selectTechnicianButton.bounds.height / 2

        appointmentDateButton.setTitle(Config.appointmentDate, for: .normal)
        appointmentDateButton.setTitleColor(UIColor(hexString: "#BBBABD"), for: .normal)
        appointmentDateButton.setTitleColor(UIColor.black, for: .selected)
        appointmentDateButton.borderColor = Config.gray155
        appointmentDateButton.borderWidth = Config.borderWidth
        appointmentDateButton.cornerRadius = appointmentDateButton.bounds.height / 2

        noteContainerView.borderColor = Config.gray155
        noteContainerView.borderWidth = Config.borderWidth
        noteContainerView.cornerRadius = noteContainerView.bounds.height / 2

        addServiceButton.borderColor = Config.gray155
        addServiceButton.borderWidth = Config.borderWidth
        addServiceButton.cornerRadius = addServiceButton.bounds.height / 2

        confirmButton.borderColor = Config.gray155
        confirmButton.borderWidth = Config.borderWidth
        confirmButton.cornerRadius = confirmButton.bounds.height / 2
    }

    private func configCollectionViews() {
        designCollectionView.register(UINib(nibName: "BookAppointDesignCell", bundle: nil), forCellWithReuseIdentifier: "BookAppointDesignCell")
        let designFlowLayout = UICollectionViewFlowLayout()
        designFlowLayout.scrollDirection = .horizontal
        designCollectionView.collectionViewLayout = designFlowLayout
        designCollectionView.dataSource = self
        designCollectionView.delegate = self
        designCollectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10)
        designCollectionViewHeightConstraint.constant = designCollectionCellSize.width + 0.7 * designCollectionCellSize.width

        technicianCollectionView.register(UINib(nibName: "BookAppointTechCell", bundle: nil), forCellWithReuseIdentifier: "BookAppointTechCell")
        let techFlowLayout = UICollectionViewFlowLayout()
        techFlowLayout.scrollDirection = .horizontal
        technicianCollectionView.collectionViewLayout = techFlowLayout
        technicianCollectionView.dataSource = self
        technicianCollectionView.delegate = self
        technicianCollectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10)
        technicianCollectionViewHeightConstraint.constant = technicianCollectionCellSize.width + 0.7 * technicianCollectionCellSize.width
        view.layoutIfNeeded()

        designCollectionView.reloadData()
        technicianCollectionView.reloadData()
    }

    private func configServiceInfoView() {
        servicesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for data in viewModel.serviceSelectedInfoList.enumerated() {
            let serviceView: ServiceInfoView = ServiceInfoView.loadNib()
            serviceView.viewModel = ServiceInfoViewModel(serviceInfo: data.element,
                                                         isShowWaitButton: viewModel.serviceSelectedInfoList.count > 1 && data.offset < viewModel.serviceSelectedInfoList.count - 1,
                                                         isCanDelete: viewModel.serviceSelectedInfoList.count > 1)
            serviceView.delegate = self
            servicesStackView.addArrangedSubview(serviceView)
        }
        totalAmountLabel.text = viewModel.totalAmount
        servicesStackView.layoutIfNeeded()
    }

    private func configDatePicker() {
        dateTextField.frame.size = .zero
        view.addSubview(dateTextField)
        datePicker.datePickerMode = .dateAndTime
        datePicker.contentMode = .center
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        // Toolbar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        // Done btn
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDatePicker))
        toolBar.setItems([doneButton], animated: true)
        // Assign tool bar
        dateTextField.inputAccessoryView = toolBar
        // Assign Date Picker to the textfield
        dateTextField.inputView = datePicker
    }

    @objc private func doneDatePicker() {
        view.endEditing(true)
        let dateStr = dateFormatter.string(from: datePicker.date)
        appointmentDateButton.setTitle(dateStr, for: .normal)
        appointmentDateButton.isSelected = true
    }

    private func getServiceInfo() {
        viewModel.getServiceList { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success:
                guard let firstService = this.viewModel.serviceSelectedInfoList.first else { return }
                this.addProductToCart(product: firstService, isNeedAppendService: false)
            case .failure(let error):
                this.showAlert(title: "", message: error.localizedDescription)
            }
        }
    }

    private func checkExitsCart() {
        HUD.show()
        viewModel.getExitsCart { [weak self] result in
            HUD.popActivity()
            guard let this = self else { return }
            switch result {
            case .success:
                if this.viewModel.cartDetail?.id != nil {
                    this.getServiceInfo()
                } else {
                    this.createCart()
                }
            case .failure(let error):
                this.showAlert(title: "", message: error.localizedDescription)
            }
        }
    }

    private func createCart() {
        HUD.show()
        viewModel.createCart { [weak self] result in
            HUD.popActivity()
            guard let this = self else { return }
            switch result {
            case .success:
                this.getServiceInfo()
            case .failure(let error):
                this.showAlert(title: "", message: error.localizedDescription)
            }
        }
    }

    private func addProductToCart(product: Service, isNeedAppendService: Bool) {
        HUD.show()
        viewModel.addProductToCart(product: product) { [weak self] result in
            HUD.popActivity()
            guard let this = self else { return }
            #warning("Please rehandle it when api done")
            this.configServiceInfoView()
            switch result {
            case .success:
                if isNeedAppendService {
                    this.viewModel.addNewService(product)
                }
                // this.configServiceInfoView()
            case .failure(let error):
                this.showAlert(title: "", message: error.localizedDescription)
            }
        }
    }

    // MARK: - IBActions
    @IBAction private func confirmButtonTouchUpInside(_ sender: UIButton) {
        let vc = ConfirmBookingVC()
        vc.viewModel = ConfirmBookingVM(serviceBooked: viewModel.serviceSelectedInfoList)
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction private func addServiceButtonTouchUpInside(_ sender: UIButton) {
        let vc = ServiceListVC()
        vc.viewModel = ServiceListVM(serviceList: viewModel.serviceSelectedInfoList)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction private func useYourDesignButtonTouchUpInside(_ sender: UIButton) {
    }

    @IBAction private func selectTechnicianButtonTouchUpInside(_ sender: UIButton) {
        let vc = TechnicianListVC()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction private func appointmentDateButtonTouchUpInside(_ sender: UIButton) {
        dateTextField.becomeFirstResponder()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension BookAppointmentVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case designCollectionView:
            return viewModel.designerList.count
        case technicianCollectionView:
            return viewModel.technicianList.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case designCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookAppointDesignCell", for: indexPath) as? BookAppointDesignCell else { return UICollectionViewCell() }
            cell.viewModel = viewModel.getBookAppointDesignCellModel(atIndexPath: indexPath)
            return cell
        case technicianCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookAppointTechCell", for: indexPath) as? BookAppointTechCell else { return UICollectionViewCell() }
            cell.viewModel = viewModel.getBookAppointTechCellModel(atIndexPath: indexPath)
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case designCollectionView:
            return designCollectionCellSize
        case technicianCollectionView:
            return technicianCollectionCellSize
        default:
            return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Config.cellSpacing
    }
}

// MARK: - UICollectionViewDelegate
extension BookAppointmentVC: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case designCollectionView:
            viewModel.updateServiceDesign(atIndexPath: indexPath)
            designCollectionView.reloadData()
        case technicianCollectionView:
            viewModel.updateServiceTechnician(atIndexPath: indexPath)
            technicianCollectionView.reloadData()
        default:
            break
        }
        configServiceInfoView()
    }
}

// MARK: - ServiceInfoViewDelegate
extension BookAppointmentVC: ServiceInfoViewDelegate {

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

// MARK: - ServiceListVCDelegate
extension BookAppointmentVC: ServiceListVCDelegate {
    func controller(_ controller: ServiceListVC, needPerformAcion action: ServiceListVC.Action) {
        switch action {
        case .selectedService(let serviceInfo):
            addProductToCart(product: serviceInfo, isNeedAppendService: true)
        }
    }
}

// MARK: - TechnicianListVCDelegate
extension BookAppointmentVC: TechnicianListVCDelegate {

    func controller(_ controller: TechnicianListVC, needPerformAction action: TechnicianListVC.Action) {
        switch action {
        case .selectService(let serviceInfo):
            addProductToCart(product: serviceInfo, isNeedAppendService: true)
        }
    }
}

// MARK: - Config
extension BookAppointmentVC {
    struct Config {
        static let title: String = "Book an Appointment"
        static let appointmentDate: String = "Select date time"
        static let total: String = "Total:"
        static let corner: CGFloat = 12
        static let borderWidth: CGFloat = 2
        static let gray155: UIColor = UIColor(red: 155, green: 155, blue: 155)
        static let cellSpacing: CGFloat = 30
        static let ok: String = "OK"
        static let bookCompleted: String = "Book completed!"
    }
}
