//
//  SortViewController.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/06/29.
//

import UIKit

enum SortType: Int, CaseIterable {
    case mostRecommended, highestRating, mostReviewed
    
    var title: String {
        switch self {
        case .mostRecommended:
            return "Most recommended"
        case .highestRating:
            return "Highest Rating"
        case .mostReviewed:
            return "Most reviewed"
        }
    }
}

final class SortViewController: BaseViewController {
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var applyButton: UIButton!
    
    // MARK: - Variables
    var viewModel: SortViewModel!
    
    private var itemSelection: [IndexPath: Bool] = [:] {
        didSet {
            applyButton.isEnabled = itemSelection.contains(where: { $0.value })
            applyButton.backgroundColor = applyButton.isEnabled ? .systemRed : .lightGray
        }
    }
    
    // MARK: - Life Cycle

    override func setupViews() {
        applyButton.backgroundColor = .lightGray
        tableView.register(SortTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction private func apply() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func reset() {
        itemSelection.removeAll()
        tableView.reloadData()
    }
}

extension SortViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SortType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SortTableViewCell.self)
        let type = SortType.allCases[indexPath.row]
        cell.isSelected = itemSelection[indexPath] ?? false
        cell.bind(title: type.title, isDisabledSeparator: indexPath.row == 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if itemSelection[indexPath] == true {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        itemSelection[indexPath] = false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemSelection[indexPath] = true
    }
}
