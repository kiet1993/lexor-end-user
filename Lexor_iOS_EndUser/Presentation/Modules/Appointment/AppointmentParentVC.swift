//
//  AppointmentParentVC.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 7/4/21.
//

import UIKit

final class AppointmentParentVC: BaseViewController {

    // MARK: - IBOutlets
    @IBOutlet private var menuButtons: [UIButton]!
    @IBOutlet private weak var pageScrollView: UIScrollView!
    @IBOutlet private weak var upComingTableView: UITableView!
    @IBOutlet private weak var pastTableView: UITableView!

    private let kScreenSize = UIScreen.main.bounds

    private var pageIndex: Int = 0
    private var pageOffsetX: CGFloat {
        let contentOffsetX = pageScrollView.contentOffset.x
        let scrollOffsetX = CGFloat(contentOffsetX / kScreenSize.width)
        return fmod(scrollOffsetX, CGFloat(menuButtons.count))
    }

    // MARK: - Properties
    enum MenuType: Int {
        case upComming = 0, past
    }

    var viewModel: AppointmentParentVM = AppointmentParentVM()
    var serviceToBooked: Service?

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configBase()
        setCustomtBackBarButton()
        configTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - Private
    private func configBase() {
        title = Config.title
        pageScrollView.delegate = self
        menuButtons.forEach {
            $0.cornerRadius = $0.bounds.height / 2
            $0.borderWidth = 1
            $0.borderColor = $0.tag == self.pageIndex ? UIColor.darkGray : UIColor.white
        }
    }

    private func configTableView() {
        upComingTableView.register(AppointmentTableCell.self)
        upComingTableView.dataSource = self
        upComingTableView.delegate = self

        pastTableView.register(AppointmentTableCell.self)
        pastTableView.dataSource = self
        pastTableView.delegate = self
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

    // MARK: - Public

    // MARK: - IBActions
    @IBAction private func menuButtonTouchUpInside(_ sender: UIButton) {
        menuButtons.forEach {
            $0.isSelected = $0.tag == sender.tag
            $0.borderColor = $0.tag == sender.tag ? UIColor.darkGray : .white
        }
        pageScrollView.setContentOffset(CGPoint(x: CGFloat(sender.tag) * kScreenSize.width, y: 0), animated: true)
    }
}

// MARK: - UITableViewDataSource
extension AppointmentParentVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case upComingTableView:
            return viewModel.upCommingList.count
        case pastTableView:
            return viewModel.pastList.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AppointmentTableCell = tableView.dequeue(AppointmentTableCell.self)
        cell.delegate = self
        switch tableView {
        case upComingTableView:
            cell.viewModel = viewModel.getAppointmentTableCellModel(ofMenu: .upComming, atIndexPath: indexPath)
        case pastTableView:
            cell.viewModel = viewModel.getAppointmentTableCellModel(ofMenu: .past, atIndexPath: indexPath)
        default:
            break
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AppointmentParentVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

// MARK: - UIScrollViewDelegate
extension AppointmentParentVC: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch scrollView {
        case pageScrollView:
            let currentIndex: Int = lround(Double(pageOffsetX)) % menuButtons.count
            if currentIndex != self.pageIndex {
                self.pageIndex = currentIndex
            }
        default:
            break
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch scrollView {
        case pageScrollView:
            if let button = menuButtons.first(where: { $0.tag == pageIndex }) {
                menuButtonTouchUpInside(button)
            }
        default:
            break
        }
    }
}

// MARK: - AppointmentTableCellDelegate
extension AppointmentParentVC: AppointmentTableCellDelegate {

    func cell(_ cell: AppointmentTableCell, needPerformAction action: AppointmentTableCell.Action) {
        switch action {
        case .rebook(_):
            guard let menuType = MenuType(rawValue: pageIndex), menuType == .past else { return }
            /*
            guard let data = viewModel.pastList[safe: indexPath.row] else { return }
            var date: Date = Date()
            if let dateTmp = DateFormatter.normalDateFormatter.date(from: data.designSchedule) {
                date = dateTmp
            }
             */
            #warning("Update later")
            serviceToBooked = nil
            if serviceToBooked == nil {
                showAlert(title: "", message: Config.canNotBookService)
            } else {
                checkRequireLogin()
            }
        case .review(let indexPath):
            let vc = ReviewViewController()
            vc.viewModel = ReviewViewModel(shopName: viewModel.pastList[safe: indexPath.row]?.salonName ?? "")
            let nc = UINavigationController(rootViewController: vc)
            nc.modalPresentationStyle = .fullScreen
            present(nc, animated: true)
        case .touchFavourite(let indexPath):
            guard let menuType = MenuType(rawValue: pageIndex) else { return }
            viewModel.favoriteAppointment(ofMenu: menuType, atIndexPath: indexPath)
            switch menuType {
            case .upComming:
                upComingTableView.reloadRows(at: [indexPath], with: .none)
            case .past:
                pastTableView.reloadRows(at: [indexPath], with: .none)
            }
        case .edit(_):
            guard let menuType = MenuType(rawValue: pageIndex), menuType == .upComming else { return }
            /*
            guard let data = viewModel.upCommingList[safe: indexPath.row] else { return }
            var date: Date = Date()
            if let dateTmp = DateFormatter.apiDateFormatter.date(from: data.designSchedule) {
                date = dateTmp
            }
             */
            #warning("Update later")
            serviceToBooked = nil
            if serviceToBooked == nil {
                showAlert(title: "", message: Config.canNotEditService)
            } else {
                checkRequireLogin()
            }
        case .cancel(let indexPath):
            showAlert(title: "", message: Config.cancelAlertMessage, buttonTitles: [Config.okTitle, Config.cancelTitle], completion: { [weak self] buttonIndex in
                guard let this = self else { return }
                switch buttonIndex {
                case 0:
                    guard let menuType = MenuType(rawValue: this.pageIndex), menuType == .upComming else { return }
                    this.viewModel.cancelAppointment(atIndexPath: indexPath)
                    this.upComingTableView.reloadData()
                default:
                    break
                }
            })
        }
    }
}

// MARK: - DashboardAuthenticationViewControllerDelegate
extension AppointmentParentVC: DashboardAuthenticationViewControllerDelegate {

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
extension AppointmentParentVC {

    struct Config {
        static let title: String = "Appointments"
        static let cancelAlertMessage: String = "Do you want to cancel this appointment?"
        static let okTitle: String = "OK"
        static let cancelTitle: String = "Cancel"
        static let canNotBookService: String = "Wrong service, can not rebook!"
        static let canNotEditService: String = "Wrong service, can not edit!"
        static let menuScrollLeftPadding: CGFloat = 22 // get from xib layout
    }
}
