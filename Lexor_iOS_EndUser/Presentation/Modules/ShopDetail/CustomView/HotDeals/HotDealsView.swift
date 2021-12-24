//
//  HotDealsView.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. VN.Danang on 7/2/21.
//

import UIKit

protocol HotDealsViewDelegate: AnyObject {
    func view(_ view: HotDealsView, needsPerform action: HotDealsView.Action)
}

final class HotDealsView: UIView {
    
    enum Action {
        case order(service: Service)
    }
    
    private struct Constants {
        static let collectionInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
    }
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let kScreenSize: CGSize = UIScreen.main.bounds.size
    weak var delegate: HotDealsViewDelegate?
    var viewModel: HotDealsViewModel? {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(HotDealCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func commonInit() {
        if let view = Bundle.main.loadNibNamed("HotDealsView", owner: self)?.first as? UIView {
            addSubview(view)
            view.snp.makeConstraints { $0.edges.equalToSuperview() }
        }
    }
    
    private func update() {
        collectionView.reloadData()
    }
}

extension HotDealsView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfRows(inSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else { return UICollectionViewCell() }
        let cell = collectionView.dequeue(HotDealCell.self, at: indexPath)
        cell.delegate = self
        cell.viewModel = viewModel.viewModelForRow(at: indexPath)
        return cell
    }
}

extension HotDealsView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let edge: CGFloat = (kScreenSize.width - 54.0) / 2
        return CGSize(width: edge, height: edge)
    }
}

extension HotDealsView: HotDealCellDelegate {
    
    func cell(_ cell: HotDealCell, needsPerform action: HotDealCell.Action) {
        switch action {
        case .order(let service):
            delegate?.view(self, needsPerform: .order(service: service))
        }
    }
}
