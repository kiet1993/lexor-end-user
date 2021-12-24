//
//  TechnicianListVC.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 7/10/21.
//

import UIKit

protocol TechnicianListVCDelegate: AnyObject {

    func controller(_ controller: TechnicianListVC, needPerformAction action: TechnicianListVC.Action)
}

final class TechnicianListVC: BaseViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    enum Action {
        case selectService(service: Service)
    }

    private var viewModel = TechnicianListVM()
    weak var delegate: TechnicianListVCDelegate?
    var comeFrom: ComeFrom = .another
    private var serviceToBooked: Service?

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configTableView()
        getData()
    }

    // MARK: - Private
    private func configUI() {
        title = Config.title
    }

    private func configTableView() {
        tableView.register(TechnicianListCell.self)
        tableView.register(TechnicianListServiceChildCell.self)
        tableView.dataSource = self
        tableView.estimatedRowHeight = 800
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func getData() {
        viewModel.getTechnicianList { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success:
                this.tableView.reloadData()
            case .failure(let error):
                this.showAlert(title: "", message: error.localizedDescription)
            }
        }
    }

    private func checkRequireLogin() {
        guard let service = serviceToBooked else { return }
        if AccountManager.shared.shouldLogin {
            let vc = DashboardAuthenticationViewController()
            vc.delegate = self
            let nc = UINavigationController(rootViewController: vc)
            nc.modalPresentationStyle = .overFullScreen
            present(nc, animated: true)
        } else {
            let vc = BookAppointmentVC()
            vc.viewModel = BookAppointmentVM(serviceSelectedInfoList: [service])
            serviceToBooked = nil
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource
extension TechnicianListVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.technicianPresentList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let presentTupleData = viewModel.technicianPresentList[safe: indexPath.row] else { return UITableViewCell() }
        switch presentTupleData.cellType {
        case .technicianCell:
            let cell = tableView.dequeue(TechnicianListCell.self)
            cell.viewModel = viewModel.getTechnicianListCellModel(atIndexPath: indexPath)
            cell.delegate = self
            return cell
        case .serviceCell:
            let cell = tableView.dequeue(TechnicianListServiceChildCell.self)
            cell.viewModel = viewModel.getServiceListCellModel(atIndexPath: indexPath)
            cell.delegate = self
            return cell
        }
    }
}

// MARK: - TechnicianListCellDelegate
extension TechnicianListVC: TechnicianListCellDelegate {
    func cell(_ cell: TechnicianListCell, needPerformAction action: TechnicianListCell.Action) {
        switch action {
        case .didTapFavorite(let indexPath):
            viewModel.updateFavoriteState(ofIndexPath: indexPath)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

// MARK: - TechnicianListServiceChildCell
extension TechnicianListVC: TechnicianListServiceChildCellDelegate {
    func cell(_ cell: TechnicianListServiceChildCell, needPerformAction action: TechnicianListServiceChildCell.Action) {
        switch action {
        case .bookService(let indexPath):
            showAlert(title: "", message: Config.selectedAlertMessage, buttonTitles: [Config.okTitle, Config.cancelTitle], completion: { [weak self] buttonIndex in
                guard let this = self else { return }
                switch buttonIndex {
                case 0:
                    guard let serviceInfo = (this.viewModel.technicianPresentList[safe: indexPath.row]?.data as? TechnicianListVM.ServiceCellData)?.serviceInfo else { return }
                    switch this.comeFrom {
                    case .bookingScreen:
                        this.delegate?.controller(this, needPerformAction: .selectService(service: serviceInfo))
                        this.navigationController?.popViewController(animated: true)
                    case .another:
                        this.serviceToBooked = serviceInfo
                        this.checkRequireLogin()
                    }
                default:
                    break
                }
            })
        }
    }
}

// MARK: - DashboardAuthenticationViewControllerDelegate
extension TechnicianListVC: DashboardAuthenticationViewControllerDelegate {

    func controller(_ controller: DashboardAuthenticationViewController, needsPerform action: DashboardAuthenticationViewController.Action) {
        switch action {
        case .cancel:
            dismiss(animated: true)
        case .update:
            dismiss(animated: true)
            guard let service = serviceToBooked else { return }
            let vc = BookAppointmentVC()
            vc.viewModel = BookAppointmentVM(serviceSelectedInfoList: [service])
            serviceToBooked = nil
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - Config
extension TechnicianListVC {

    enum ComeFrom {
        case bookingScreen
        case another
    }

    struct Config {
        static let title: String = "Technicians"
        static let selectedAlertMessage: String = "Do you want to book this service?"
        static let okTitle: String = "OK"
        static let cancelTitle: String = "Cancel"
    }
}
