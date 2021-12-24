//
//  HomeViewController.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/05/24.
//

import UIKit

final class HomeViewController: BaseViewController {
    enum CellType {
        case hotDeals([ProductModel])
        case vipServices([ProductModel])
        case bestArtists([BestNailArtistModel])
        case smallTalks([SmallTalkModel])
        case ads([AdModel])
        
        var index: Int {
            switch self {
            case .hotDeals:
               return 0
            case .vipServices:
               return 1
            case .bestArtists:
               return 2
            case .smallTalks:
               return 3
            case .ads:
                return 4
            }
        }
        
        var title: String {
            switch self {
            case .hotDeals:
               return "Hot deals"
            case .vipServices:
               return "VIP services"
            case .bestArtists:
               return "Best Nail Artist"
            case .smallTalks:
               return "Small Talks"
            case .ads:
                return "ads"
            }
        }
        
        static func == (lhs: CellType, rhs: CellType) -> Bool {
            lhs.index == rhs.index
        }
    }

    //MARK: - Outlets
    @IBOutlet private weak var headerTitleLabel: UILabel!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var searchView: UIView!
    @IBOutlet private weak var headerTopContraint: NSLayoutConstraint!
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var quickMenuCollectionView: UICollectionView!
    
    private var maxHeight: CGFloat {
        return 300 - (AppDelegate.shared?.window?.safeAreaInsets.top ?? 0)
    }
    private let minHeight: CGFloat = 120
    
    private var cells: [CellType] = []
    
    var viewModel: HomeType!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func setupViews() {
        super.setupViews()
        searchButton.cornerRadius = 5
        searchButton.setImage(#imageLiteral(resourceName: "ic_search").withRenderingMode(.alwaysTemplate), for: .normal)
        
        searchView.cornerRadius = 5
        searchView.shadowColor = .black
        searchView.shadowOffset = .zero
        searchView.shadowOpacity = 0.3
        searchView.shadowRadius = 4
        searchView.layer.masksToBounds = false
        
        
        quickMenuCollectionView.register(QuickMenuCollectionViewCell.self)
        quickMenuCollectionView.dataSource = self
        quickMenuCollectionView.delegate = self
        
        tableView.register(AdsTableViewCell.self)
        tableView.register(CategoryTableViewCell.self)
        tableView.contentInset.top = maxHeight
        tableView.contentInset.bottom = 10
        tableView.delegate = self
        tableView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onSearchPressed))
        searchView.addGestureRecognizer(tap)
    }

    override func setupViewModel() {
        super.setupViewModel()
        
        viewModel.output
            .onRecievedHotDeals
            .observe(onQueue: .main) { [unowned self] items in
                self.reloadData(with: .hotDeals(items))
            }
        
        viewModel.output
            .onRecievedVipServices
            .observe(onQueue: .main) { [unowned self] items in
                self.reloadData(with: .vipServices(items))
            }
        
        viewModel.output
            .onRecievedBestNailArtists
            .observe(onQueue: .main) { [unowned self] items in
                self.reloadData(with: .bestArtists(items))
            }
        
        viewModel.input.fetchData()
    }
    
    private func reloadData(with type: CellType) {
        cells.append(type)
        cells.sort(by: { $0.index < $1.index })
        tableView.reloadData()
    }
    
    @objc private func onSearchPressed() {
        viewModel.input.toSearch()
    }
    
    private func updateHeaderConstaint(_ constant: CGFloat) {
        headerTopContraint.constant = constant
        view.layoutIfNeeded()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        cells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = cells[indexPath.section]
        
        switch type {
        case .ads(let models):
            let cell = tableView.dequeue(AdsTableViewCell.self)
            cell.bind(ads: models)
            return cell
        default:
            let cell = tableView.dequeue(CategoryTableViewCell.self)
            cell.bind(type: type)
            cell.selectionHandler = { [unowned self] in
                let vc = ShopDetailViewController()
                #warning("DucPD Please provide id for ShopDetail screen")
                vc.viewModel = ShopDetailViewModel(id: "1")
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = cells[indexPath.section]
        switch type {
        case .bestArtists, .hotDeals, .vipServices:
            return 200
        case .smallTalks:
            return 280
        case .ads:
            return 150
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = -scrollView.contentOffset.y
        let minOffset = max(minHeight, offsetY)
        if minOffset < maxHeight {
            // header collapsed
            let newConstant = minOffset - maxHeight
            updateHeaderConstaint(newConstant)
        } else {
            // header fully expanded
            updateHeaderConstaint(0)
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.bounds.width / 3, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        15
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        QuickMenuType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(QuickMenuCollectionViewCell.self, at: indexPath)
        cell.bind(type: QuickMenuType.allCases[indexPath.row])
        return cell
    }
}
