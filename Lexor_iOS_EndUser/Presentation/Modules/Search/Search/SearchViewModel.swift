//
//  SearchViewModel.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/06/29.
//

import Foundation

protocol SearchInput {
    func dismiss()
    func navigateToFilter()
    func navigateToSort()
    func search(keyword: String)
}

protocol SearchOutput {
    var onRecievedShops: PublishDynamic<[ShopItemModel]> { get }
    var onRecievedError: PublishDynamic<Error> { get }
}

protocol SearchType {
    var input: SearchInput { get }
    var output: SearchOutput { get }
}

extension SearchType where Self: SearchInput & SearchOutput {
    var input: SearchInput { return self }
    var output: SearchOutput { return self }
}

final class SearchViewModel: SearchType, SearchOutput {
    var onRecievedShops: PublishDynamic<[ShopItemModel]> = .init()
    var onRecievedError: PublishDynamic<Error> = .init()
    
    private unowned var navigator: SearchNavigator
    
    init(navigator: SearchNavigator) {
        self.navigator = navigator
    }
    
    func search(keyword: String, completion: @escaping APICompletionValue<[ShopItemModel]>) {
        NetworkService.shared.searchShopName(keyword: keyword) { result in
            switch result {
            case .success(let value):
                completion(.success(value.items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension SearchViewModel: SearchInput {
    func search(keyword: String) {
        search(keyword: keyword) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let value):
                self.onRecievedShops.onEvent(value)
            case .failure(let error):
                self.onRecievedError.onEvent(error)
            }
        }
    }
    
    func navigateToFilter() {
        navigator.toFilter()
    }
    
    func navigateToSort() {
        navigator.toSort()
    }
    
    func dismiss() {
        navigator.dismiss()
    }
}
