//
//  AdsTableViewCell.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/07/26.
//

import UIKit

class AdsTableViewCell: UITableViewCell {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageView: UIPageControl!
    
    private var ads: [AdModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(ImageCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func bind(ads: [AdModel]) {
        self.ads = ads
        pageView.numberOfPages = ads.count
        collectionView.reloadData()
    }
}
extension AdsTableViewCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        pageView.currentPage = page
    }
}

extension AdsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        .leastNonzeroMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        .leastNonzeroMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ads.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(ImageCollectionViewCell.self, at: indexPath)
        cell.bind(url: ads[indexPath.row].image)
        return cell
    }
}
