//
//  SearchCoordinator.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/06/29.
//

import UIKit

protocol SearchNavigator: AnyObject {
    func toFilter()
    func toSort()
    func dismiss()
}

final class SearchCoordinator: BaseCoordinator {
    
    init() {
        super.init(rootNavigationController: UINavigationController())
    }

    override func start() {
        rootNavigationController.setNavigationBarHidden(true, animated: false)
        let vc = SearchViewController()
        vc.viewModel = SearchViewModel(navigator: self)
        setRoot(vc)
    }
    
    override func finish() {
        dismiss(animated: true) { [weak self] in
            self?.removeFromParent()
        }
    }
}

extension SearchCoordinator: SearchNavigator {
    func toSort() {
        let vc = SortViewController()
        vc.viewModel = .init(navigator: self)
        push(vc)
    }
    
    func toFilter() {
        let vc = FilterViewController()
        vc.viewModel = .init(navigator: self)
        push(vc)
    }
    
    func dismiss() {
        finish()
    }
}
