//
//  FilterViewController.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/06/29.
//

import UIKit

enum FilterType: Int, CaseIterable {
    case distance, workingHours, popular, amenities, paymentType
    
    var title: String {
        switch self {
        case .distance:
            return "Distance"
        case .workingHours:
            return "Working Hours"
        case .popular:
            return "Popular"
        case .amenities:
            return "Amenities"
        case .paymentType:
            return "Payment Type"
        }
    }
    
    var isSingleChoice: Bool {
        switch self {
        case .distance:
            return true
        case .workingHours:
            return true
        case .popular:
            return true
        case .amenities:
            return true
        case .paymentType:
            return true
        }
    }
    
    var cases: [String] {
        switch self {
        case .distance:
            return DistanceType.allCases.map({ $0.title })
        case .workingHours:
            return WorkingHourType.allCases.map({ $0.title })
        case .popular:
            return PopularType.allCases.map({ $0.title })
        case .amenities:
            return AmenityType.allCases.map({ $0.title })
        case .paymentType:
            return PaymentType.allCases.map({ $0.title })
        }
    }
    
    func titleFor(index: Int) -> String {
        return cases[index]
    }
}

enum DistanceType: Int, CaseIterable {
    case nearest, oneMile, twoMile, threeMile
    
    var title: String {
        switch self {
        case .nearest:
            return "Nearest"
        case .oneMile:
            return "1 mile"
        case .twoMile:
            return "2 miles"
        case .threeMile:
            return "3 miles"
        }
    }
}

enum WorkingHourType: Int, CaseIterable  {
    case availableNow
    
    var title: String {
        switch self {
        case .availableNow:
            return "Available Now"
        }
    }
}

enum PopularType: Int, CaseIterable {
    case offerADeal, hotAndNew, restrooms, additionalServices
    
    var title: String {
        switch self {
        case .offerADeal:
            return "Offer a deal"
        case .hotAndNew:
            return "Hot and New"
        case .restrooms:
            return "Gender-neutral Restrooms"
        case .additionalServices:
            return "Additional services"
        }
    }
}

enum AmenityType: Int, CaseIterable {
    case freeWifi, wheelChair, openToAll, parkingLot
    
    var title: String {
        switch self {
        case .freeWifi:
            return "Free wifi"
        case .wheelChair:
            return "Wheel chair accessible"
        case .openToAll:
            return "Open to all"
        case .parkingLot:
            return "Parking lot"
        }
    }
}

enum PaymentType: Int, CaseIterable {
    case cash, card, eWallet
    
    var title: String {
        switch self {
        case .cash:
            return "Cash"
        case .card:
            return "Credit/Debit"
        case .eWallet:
            return "E-wallet"
        }
    }
}

final class FilterViewController: BaseViewController {
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var applyButton: UIButton!
    
    // MARK: - Variables
    var viewModel: FilterViewModel!
    
    private var itemSelection: [Int: IndexPath] = [:]
    
    // MARK: - Life Cycle
    override func setupViews() {
        tableView.register(FilterTableViewCell.self)
        tableView.register(FilterHeaderView.self)
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

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        FilterType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let type = FilterType.allCases[section]
        return type.cases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(FilterTableViewCell.self)
        let type = FilterType.allCases[indexPath.section]
        cell.bind(title: type.titleFor(index: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if itemSelection[indexPath.section] == indexPath {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeue(FilterHeaderView.self)
        let type = FilterType.allCases[section]
        view.bind(title: type.title, isDisabledSeparator: section == 0)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemSelection[indexPath.section] = indexPath
        tableView.reloadData()
    }
}
