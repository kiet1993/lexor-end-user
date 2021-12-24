//
//  HomeViewModel.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/05/24.
//

import Foundation

protocol HomeInput {
    func fetchData()
    func toSearch()
}

protocol HomeOutput {
    var onRecievedHotDeals: PublishDynamic<[ProductModel]> { get }
    var onRecievedVipServices: PublishDynamic<[ProductModel]> { get }
    var onRecievedBestNailArtists: PublishDynamic<[BestNailArtistModel]> { get }
    var onRecievedError: PublishDynamic<Error> { get }
}

protocol HomeType {
    var input: HomeInput { get }
    var output: HomeOutput { get }
}

extension HomeType where Self: HomeInput & HomeOutput {
    var input: HomeInput { return self }
    var output: HomeOutput { return self }
}

class HomeViewModel: HomeType, HomeOutput {
    var onRecievedHotDeals: PublishDynamic<[ProductModel]> = .init()
    var onRecievedVipServices: PublishDynamic<[ProductModel]> = .init()
    var onRecievedBestNailArtists: PublishDynamic<[BestNailArtistModel]> = .init()
    var onRecievedError: PublishDynamic<Error> = .init()
    
    private let navigator: AppNavigator
    
    init(navigator: AppNavigator) {
        self.navigator = navigator
    }
    
    func fetchHotDeals() {
        NetworkService.shared.fetchHotDeals(currentPage: 1, pageSize: 10) { [weak self] result in
            switch result {
            case .success(let value):
                self?.onRecievedHotDeals.onEvent(value.items)
            case .failure(let error):
                self?.onRecievedError.onEvent(error)
            }
        }
    }
    
    func fetchVipServices() {
        NetworkService.shared.fetchVipServices(currentPage: 1, pageSize: 10) { [weak self] result in
            switch result {
            case .success(let value):
                self?.onRecievedVipServices.onEvent(value.items)
            case .failure(let error):
                self?.onRecievedError.onEvent(error)
            }
        }
    }
    
    func fetchBestNailArtists() {
        NetworkService.shared.fetchTechnicians(currentPage: 1, pageSize: 10) { [weak self] result in
            switch result {
            case .success(let value):
                self?.onRecievedBestNailArtists.onEvent(value.items)
            case .failure(let error):
                self?.onRecievedError.onEvent(error)
            }
        }
    }
}

extension HomeViewModel: HomeInput {
    func toSearch() {
        navigator.toSearch()
    }
    
    func fetchData() {
        fetchHotDeals()
        fetchVipServices()
        fetchBestNailArtists()
    }
}
