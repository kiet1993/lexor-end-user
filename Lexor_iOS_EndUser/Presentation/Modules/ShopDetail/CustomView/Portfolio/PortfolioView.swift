//
//  PortfolioView.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. VN.Danang on 7/1/21.
//

import UIKit

final class PortfolioView: UIView {
    
    private struct Constants {
        static let tableInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    @IBOutlet private weak var selectionView: UIView!
    @IBOutlet private weak var contentScrollView: UIScrollView!
    @IBOutlet private weak var salonSpaceTableView: UITableView!
    @IBOutlet private weak var nailDesingsTableView: UITableView!
    
    private let kScreenSize = UIScreen.main.bounds
    private var scrollOffsetX: CGFloat {
        let contentOffsetX = contentScrollView.contentOffset.x
        let scrollOffsetX = CGFloat(contentOffsetX / kScreenSize.width)
        return fmod(scrollOffsetX, 2)
    }
    
    var viewModel: PortfolioViewModel? {
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
        contentScrollView.delegate = self
        
        salonSpaceTableView.register(SalonSpaceCell.self)
        salonSpaceTableView.dataSource = self
        salonSpaceTableView.contentInset = Constants.tableInset
        
        nailDesingsTableView.register(NailDesignsCell.self)
        nailDesingsTableView.dataSource = self
        nailDesingsTableView.contentInset = Constants.tableInset
    }
    
    private func commonInit() {
        if let view = Bundle.main.loadNibNamed("PortfolioView", owner: self)?.first as? UIView {
            addSubview(view)
            view.snp.makeConstraints { $0.edges.equalToSuperview() }
        }
    }
    
    private func update() { }
    
    private func updateSelectionFrame(percent: CGFloat) {
        let x: CGFloat = (kScreenSize.width - 44) * percent / 2 + 22
        selectionView.frame.origin.x = x
    }
    
    @IBAction private func itemButtonTouchUpInside(_ sender: UIButton) {
        contentScrollView.setContentOffset(CGPoint(x: CGFloat(sender.tag) * kScreenSize.width, y: 0), animated: true)
    }
}

extension PortfolioView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch scrollView {
        case contentScrollView:
            let percent: CGFloat = max(0, min(1, scrollOffsetX.truncatingRemainder(dividingBy: 2)))
            updateSelectionFrame(percent: percent)
        default:
            break
        }
    }
}

extension PortfolioView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case salonSpaceTableView:
            let cell = tableView.dequeue(SalonSpaceCell.self, indexPath: indexPath)
            return cell
        default:
            let cell = tableView.dequeue(NailDesignsCell.self, indexPath: indexPath)
            return cell
        }
    }
}
