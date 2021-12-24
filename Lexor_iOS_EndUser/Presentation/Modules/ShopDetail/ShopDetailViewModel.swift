//
//  ShopDetailViewModel.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. VN.Danang on 6/3/21.
//

import Foundation

final class ShopDetailViewModel {
    
    struct Output {
        var name: String = ""
        var images: [String] = []
        var address: String = ""
        var workHours: String = ""
        var rating: Double = 0
        var reviewsCount: Int = 0
        var isFavourite: Bool = false
        var coordinates: Coordinates = Coordinates(latitude: 0, longitude: 0)
        var openings: [StoreOpeningHour] = []
        var services: [Service] = []
        var reviews: [Review] = []
        var hotDeals: [Service] = []
        var technicians: [Technician] = []
        
        var totalReviews: String {
            return "\(reviewsCount) reviews"
        }
    }
    
    private let id: String
    private var store: Store? {
        didSet {
            updateFromStore()
        }
    }
    private var servicesPage: Int = 0
    private var servicesData: BaseResponseModel<Service>? {
        didSet {
            updateFromServices()
        }
    }
    private var reviewsPage: Int = 0
    private var reviewsData: BaseResponseModel<Review>? {
        didSet {
            updateFromReviews()
        }
    }
    private var hotDealsData: BaseResponseModel<Service>? {
        didSet {
            updateFromHotDeals()
        }
    }
    private var technicians: [Technician] = [] {
        didSet {
            updateFromTechnicians()
        }
    }
    private(set) var output: Output = Output()
    
    init(id: String) {
        self.id = id
    }
    
    private func updateFromStore() {
        guard let store = store else { return }
        output.name = store.name
        output.address = store.address
        output.workHours = store.workHours
        output.coordinates = store.storeExtension.address.coordinates
        output.openings = store.storeExtension.openings
    }
    
    private func updateFromServices() {
        guard let data = servicesData else { return }
        output.services = data.items
    }
    
    private func updateFromReviews() {
        guard let data = reviewsData else { return }
        output.reviewsCount = data.totalCount
        output.reviews = data.items
    }
    
    private func updateFromHotDeals() {
        guard let data = hotDealsData else { return }
        output.hotDeals = data.items
    }
    
    private func updateFromTechnicians() {
        output.technicians = technicians
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        return output.images.count
    }
    
    func viewModelForServicesView() -> ServicesViewModel {
        return ServicesViewModel(services: output.services)
    }
    
    func viewModelForReviewsView() -> ReviewsViewModel {
        return ReviewsViewModel(output: output)
    }
    
    func viewModelForPortfolioView() -> PortfolioViewModel {
        return PortfolioViewModel()
    }
    
    func viewModelForHotDealsView() -> HotDealsViewModel {
        return HotDealsViewModel(hotDeals: output.hotDeals)
    }
    
    func viewModelForDetailsView() -> DetailsViewModel {
        return DetailsViewModel(output: output)
    }
    
    func getStore(completion: @escaping APICompletion) {
        NetworkService.shared.getStore(id: id) { [weak self] result in
            DispatchQueue.main.async {
                guard let this = self else { return }
                switch result {
                case .success(let value):
                    this.store = value
                    completion(.success)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getServices(completion: @escaping APICompletion) {
        NetworkService.shared.getStoreServices(id: id, currentPage: servicesPage + 1) {  [weak self] result in
            DispatchQueue.main.async {
                guard let this = self else { return }
                switch result {
                case .success(let value):
                    this.servicesPage += 1
                    this.servicesData = value
                    completion(.success)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getReviews(completion: @escaping APICompletion) {
        NetworkService.shared.getStoreReviews(id: id, currentPage: reviewsPage + 1) {  [weak self] result in
            DispatchQueue.main.async {
                guard let this = self else { return }
                switch result {
                case .success(let value):
                    this.reviewsPage += 1
                    this.reviewsData = value
                    completion(.success)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getHotDeals(completion: @escaping APICompletion) {
        NetworkService.shared.getStoreHotDeals(id: id) {  [weak self] result in
            DispatchQueue.main.async {
                guard let this = self else { return }
                switch result {
                case .success(let value):
                    this.hotDealsData = value
                    completion(.success)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getTechnicians(completion: @escaping APICompletion) {
        NetworkService.shared.getStoreTechnicians(id: id) {  [weak self] result in
            DispatchQueue.main.async {
                guard let this = self else { return }
                switch result {
                case .success(let value):
                    this.technicians = value
                    completion(.success)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
