//
//  ShopDetailViewController.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. VN.Danang on 6/3/21.
//

import UIKit
import SDWebImage

final class ShopDetailViewController: BaseViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var locationButton: UIButton!
    @IBOutlet private weak var workHoursLabel: UILabel!
    @IBOutlet private weak var ratingView: RatingView!
    @IBOutlet private weak var totalReviewsLabel: UILabel!
    @IBOutlet private weak var actionView: ActionView!
    @IBOutlet private weak var itemScrollView: UIScrollView!
    @IBOutlet private var itemButtons: [UIButton]!
    @IBOutlet private weak var pageScrollView: UIScrollView!
    @IBOutlet private weak var servicesView: ServicesView!
    @IBOutlet private weak var reviewsView: ReviewsView!
    @IBOutlet private weak var portfolioView: PortfolioView!
    @IBOutlet private weak var hotDealsView: HotDealsView!
    @IBOutlet private weak var detailsView: DetailsView!
    
    private let kScreenSize = UIScreen.main.bounds
    private let group = DispatchGroup()
    private var collectionIndex: Int = 0
    private var collectionOffsetX: CGFloat {
        let contentOffsetX = collectionView.contentOffset.x
        let scrollOffsetX = CGFloat(contentOffsetX / kScreenSize.width)
        return fmod(scrollOffsetX, CGFloat(collectionView.numberOfItems(inSection: 0)))
    }
    private var pageIndex: Int = 0
    private var pageOffsetX: CGFloat {
        let contentOffsetX = pageScrollView.contentOffset.x
        let scrollOffsetX = CGFloat(contentOffsetX / kScreenSize.width)
        return fmod(scrollOffsetX, CGFloat(itemButtons.count))
    }
    var viewModel: ShopDetailViewModel!
    var serviceToBooked: Service?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        update()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func configure() {
        makeNavigationBarTransparent()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = .leastNonzeroMagnitude
        flowLayout.minimumInteritemSpacing = .leastNonzeroMagnitude
        flowLayout.sectionInset = .zero
        let itemSize = CGSize(width: kScreenSize.width, height: 200 * kScreenSize.width / 375)
        flowLayout.itemSize = itemSize
        flowLayout.estimatedItemSize = itemSize
        collectionView.collectionViewLayout = flowLayout
        collectionView.register(UICollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] timer in
            guard let this = self else { return }
            this.handleTimerAction(timer)
        }
        
        locationButton.layer.borderColor = UIColor.darkGray.cgColor
        locationButton.layer.cornerRadius = 19
        locationButton.layer.borderWidth = 1
        
        pageScrollView.delegate = self
        servicesView.delegate = self
        hotDealsView.delegate = self
        detailsView.delegate = self
        reviewsView.delegate = self
    }
    
    @objc func backBarButtonTouchUpInside() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleTimerAction(_ sender: Timer) {
        guard collectionView.numberOfSections > 0, collectionView.numberOfItems(inSection: 0) > 0 else { return }
        if collectionIndex < collectionView.numberOfItems(inSection: 0) - 1 {
            collectionIndex += 1
        } else {
            collectionIndex = 0
        }
        collectionView.scrollToItem(at: IndexPath(row: collectionIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    private func getData() {
        HUD.show()
        getStore()
        getServices()
        getReviews()
        getHotDeals()
        group.notify(queue: .main) { [weak self] in
            HUD.dismiss()
            guard let this = self else { return }
            if this.isViewLoaded && this.view.window != nil {
                this.update()
            }
        }
    }
    
    private func getStore() {
        group.enter()
        viewModel.getStore { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success:
                break
            case .failure(let error):
                this.showError(error)
            }
            this.group.leave()
        }
    }
    
    private func getServices() {
        group.enter()
        viewModel.getServices { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success:
                break
            case .failure(let error):
                this.showError(error)
            }
            this.group.leave()
        }
    }
    
    private func getReviews() {
        group.enter()
        viewModel.getReviews { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success:
                break
            case .failure(let error):
                this.showError(error)
            }
            this.group.leave()
        }
    }
    
    private func getHotDeals() {
        group.enter()
        viewModel.getHotDeals { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success:
                break
            case .failure(let error):
                this.showError(error)
            }
            this.group.leave()
        }
    }
    
    private func update() {
        collectionView.reloadData()
        nameLabel.text = viewModel.output.name
        addressLabel.text = viewModel.output.address
        workHoursLabel.text = viewModel.output.workHours
        ratingView.rating = viewModel.output.rating
        totalReviewsLabel.text = viewModel.output.totalReviews
        actionView.updateFavourite(viewModel.output.isFavourite)
        servicesView.viewModel = viewModel.viewModelForServicesView()
        reviewsView.viewModel = viewModel.viewModelForReviewsView()
        portfolioView.viewModel = viewModel.viewModelForPortfolioView()
        hotDealsView.viewModel = viewModel.viewModelForHotDealsView()
        detailsView.viewModel = viewModel.viewModelForDetailsView()
    }

    private func checkRequireLogin() {
        guard let service = serviceToBooked else { return }
        if AccountManager.shared.shouldLogin {
            let vc = DashboardAuthenticationViewController()
            vc.delegate = self
            let nc = UINavigationController(rootViewController: vc)
            nc.modalPresentationStyle = .overFullScreen
            present(nc, animated: true)
        } else {
            let vc = BookAppointmentVC()
            vc.viewModel = BookAppointmentVM(serviceSelectedInfoList: [service])
            serviceToBooked = nil
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction private func itemButtonTouchUpInside(_ sender: UIButton) {
        view.endEditing(true)
        itemButtons.forEach {
            $0.isSelected = $0.tag == sender.tag
        }
        let screenWidth = kScreenSize.width
        let centerX = sender.center.x
        var newOffsetX: CGFloat = 0
        if centerX + screenWidth / 2 > itemScrollView.contentSize.width - 20 {
            newOffsetX = itemScrollView.contentSize.width - screenWidth
        } else if centerX - screenWidth / 2 > 0 {
            newOffsetX = centerX - screenWidth / 2 + 20
        }
        itemScrollView.setContentOffset(CGPoint(x: newOffsetX, y: 0), animated: true)
        pageScrollView.setContentOffset(CGPoint(x: CGFloat(sender.tag) * screenWidth, y: 0), animated: true)
    }
}

extension ShopDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(UICollectionViewCell.self, at: indexPath)
        if let urlString = viewModel.output.images[safe: indexPath.row] {
            let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: kScreenSize.width, height: 200 * kScreenSize.width / 375)))
            imageView.sd_setImage(with: URL(string: urlString))
            cell.addSubview(imageView)
        }
        return cell
    }
}

extension ShopDetailViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch scrollView {
        case collectionView:
            let currentIndex: Int = lround(Double(collectionOffsetX)) % collectionView.numberOfItems(inSection: 0)
            if currentIndex != self.collectionIndex {
                self.collectionIndex = currentIndex
            }
        case pageScrollView:
            let currentIndex: Int = lround(Double(pageOffsetX)) % itemButtons.count
            if currentIndex != self.pageIndex {
                self.pageIndex = currentIndex
            }
        default:
            break
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch scrollView {
        case pageScrollView:
            if let button = itemButtons.first(where: { $0.tag == pageIndex }) {
                itemButtonTouchUpInside(button)
            }
        default:
            break
        }
    }
}

extension ShopDetailViewController: ServicesViewDelegate {
    func view(_ view: ServicesView, needsPerform action: ServicesView.Action) {
        switch action {
        case .didSelectService(let service):
            view.endEditing(true)
            serviceToBooked = service
            checkRequireLogin()
        }
    }
}

extension ShopDetailViewController: ReviewsViewDelegate {
    
    func view(_ view: ReviewsView, needsPerform action: ReviewsView.Action) {
        switch action {
        case .writeReview:
            let vc = ReviewViewController()
            vc.viewModel = ReviewViewModel(shopName: viewModel.output.name)
            let nc = UINavigationController(rootViewController: vc)
            nc.modalPresentationStyle = .fullScreen
            present(nc, animated: true)
        }
    }
}

extension ShopDetailViewController: HotDealsViewDelegate {
    
    func view(_ view: HotDealsView, needsPerform action: HotDealsView.Action) {
        switch action {
        case .order(let service):
            let vc = BookAppointmentVC()
            vc.viewModel = BookAppointmentVM(serviceSelectedInfoList: [service])
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ShopDetailViewController: DetailsViewDelegate {
    
    func view(_ view: DetailsView, needsPerform action: DetailsView.Action) {
        switch action {
        case .seeAllTechnicians:
            let vc = TechnicianListVC()
            vc.comeFrom = .another
            navigationController?.pushViewController(vc, animated: true)
        case .call(number: let number):
            let number = number.replacingOccurrences(of: " ", with: "")
            print(number)
            if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
}

// MARK: - DashboardAuthenticationViewControllerDelegate
extension ShopDetailViewController: DashboardAuthenticationViewControllerDelegate {

    func controller(_ controller: DashboardAuthenticationViewController, needsPerform action: DashboardAuthenticationViewController.Action) {
        switch action {
        case .cancel:
            dismiss(animated: true)
        case .update:
            dismiss(animated: true)
            guard let service = serviceToBooked else { return }
            let vc = BookAppointmentVC()
            vc.viewModel = BookAppointmentVM(serviceSelectedInfoList: [service])
            serviceToBooked = nil
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
