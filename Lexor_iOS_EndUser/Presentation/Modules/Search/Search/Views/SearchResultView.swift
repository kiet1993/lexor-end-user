//
//  SearchResultView.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/06/14.
//

import UIKit
import MapKit

protocol SearchResultViewDelegate: AnyObject {
    func searchResultViewDismiss()
    func searchResultViewNagigateToFilter()
    func searchResultViewNagigateToSort()
    func searchResultViewEdit()
}

class SearchResultView: BaseView {
    @IBOutlet private weak var keywordLabel: UILabel!
    @IBOutlet private weak var textSearchView: UIView!
    @IBOutlet private weak var mapView: MKMapView!
    
    @IBOutlet private weak var filterButton: UIButton!
    @IBOutlet private weak var sortButton: UIButton!
    
    @IBOutlet private weak var tableView: UITableView!

   
    private var shops: [ShopItemModel] = []
    
    weak var delegate: SearchResultViewDelegate?
    
    var keyword: String = "" {
        didSet {
            keywordLabel.text = keyword
        }
    }

    override func setupUI() {
        [textSearchView, sortButton, filterButton].forEach {
            $0?.cornerRadius = ($0?.bounds.height ?? 0) / 2
            $0?.borderColor = .lightGray
            $0?.borderWidth = 0.5
        }
        
        mapView.cornerRadius = 10
        
        tableView.register(SearchResultTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(editTapped))
        keywordLabel.addGestureRecognizer(tap)
        keywordLabel.isUserInteractionEnabled = true
    }
    
    func updateShops(_ shops: [ShopItemModel]) {
        self.shops = shops
        if let first = shops.first {
            mapView.centerCoordinate = .init(latitude: first.extensionAttributes.address.coordinates.latitude,
                                             longitude: first.extensionAttributes.address.coordinates.longitude)
        }
        
        tableView.reloadData()
    }
    
    @IBAction private func editTapped() {
        delegate?.searchResultViewEdit()
    }
    
    @IBAction private func back() {
        delegate?.searchResultViewDismiss()
    }
    
    @IBAction private func tapFilter() {
        delegate?.searchResultViewNagigateToFilter()
    }
    
    @IBAction private func tapSort() {
        delegate?.searchResultViewNagigateToSort()
    }
}

extension SearchResultView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SearchResultTableViewCell.self)
        cell.bind(shop: shops[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        253
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
}
