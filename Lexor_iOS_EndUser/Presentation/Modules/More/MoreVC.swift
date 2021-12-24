//
//  MoreVC.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 7/7/21.
//

import UIKit

final class MoreVC: BaseViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var headerImageView: UIImageView!
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    override var isNeedBackBarButton: Bool {
        return false
    }

    // MARK: - Life cycles
    override func setupViews() {
        super.setupViews()
        title = Config.title
        configTableView()
    }

    // MARK: - Private
    private func configTableView() {
        tableView.register(MoreTableCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource
extension MoreVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellType.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = CellType(rawValue: indexPath.row) else { return UITableViewCell() }
        let cell: MoreTableCell = tableView.dequeue(MoreTableCell.self)
        cell.viewModel = MoreTableCellModel(type: cellType)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MoreVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cellType = CellType(rawValue: indexPath.row) else { return }
        switch cellType {
        case .appointmentList:
            let vc = AppointmentParentVC()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - Base data
extension MoreVC {

    struct Config {
        static let title: String = "More"
    }

    enum CellType: Int, CaseIterable {
        case appointmentList

        var title: String {
            switch self {
            case .appointmentList: return "Appointment list"
            }
        }

        var image: UIImage? {
            switch self {
            case .appointmentList: return UIImage(named: "ic_map")
            }
        }
    }
}
