//
//  ClassicChoicesTableViewCell.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/05/25.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    var selectionHandler: (() -> Void)?
    
    private var type: HomeViewController.CellType?

    override func awakeFromNib() {
        super.awakeFromNib()
       
        collectionView.register(SmallTalkCollectionViewCell.self)
        collectionView.register(BestArtistCollectionViewCell.self)
        collectionView.register(HotDealCollectionViewCell.self)
        collectionView.register(VIPServiceCollectionViewCell.self)
        collectionView.contentInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func bind(type: HomeViewController.CellType) {
        self.type = type
        titleLabel.text = type.title
        collectionView.reloadData()
    }
}

extension CategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let type = type else {
            return .zero
        }
        
        switch type {
        case .bestArtists, .hotDeals, .vipServices:
            return .init(width: 140, height: 140)
        case .smallTalks:
            return .init(width: 140, height: 220)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectionHandler?()
    }
}

extension CategoryTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let type = type else {
            return 0
        }
        switch type {
        case .bestArtists(let models):
            return models.count
        case .hotDeals(let models):
            return models.count
        case .vipServices(let models):
            return models.count
        case .smallTalks(let models):
            return models.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let type = type else {
            fatalError("Data incorrect")
        }
        switch type {
        case .bestArtists(let models):
            let cell = collectionView.dequeue(BestArtistCollectionViewCell.self, at: indexPath)
            cell.bind(model: models[indexPath.row])
            return cell
        case .hotDeals(let products):
            let product = products[indexPath.row]
            let cell = collectionView.dequeue(HotDealCollectionViewCell.self, at: indexPath)
            cell.bind(product: product)
            return cell
        case .vipServices(let models):
            let product = models[indexPath.row]
            let cell = collectionView.dequeue(VIPServiceCollectionViewCell.self, at: indexPath)
            cell.bind(product: product)
            return cell
        case .smallTalks(let models):
            let cell = collectionView.dequeue(SmallTalkCollectionViewCell.self, at: indexPath)
            cell.bind(model: models[indexPath.row])
            return cell
        default:
            let cell = collectionView.dequeue(SmallTalkCollectionViewCell.self, at: indexPath)
            return cell
        }
    }
}
