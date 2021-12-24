//
//  SearchResultTableViewCell.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/06/15.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var shopNameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var workingHourLabel: UILabel!
    @IBOutlet private weak var specialServiceLabel: UILabel!
    
    private var shop: ShopItemModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(SearchResultImageCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func bind(shop: ShopItemModel) {
        self.shop = shop
        shopNameLabel.text = shop.name
        addressLabel.text = shop.extensionAttributes.address.street.first
        
        if let openingHours = shop.extensionAttributes.openingHours.first {
            let string = openingHours.map { openingHour in
                return openingHour.startTime + " - " + openingHour.endTime
            }.joined(separator: ",")
            workingHourLabel.text = string
        }
        
        collectionView.reloadData()
    }
}

extension SearchResultTableViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
}

extension SearchResultTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        shop?.images.count ?? 0
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(SearchResultImageCollectionViewCell.self, at: indexPath)
//        cell.bind(url: shop?.images[indexPath.row] ?? "")
        return cell
    }
}
