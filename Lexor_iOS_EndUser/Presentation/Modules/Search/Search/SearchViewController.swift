//
//  SearchViewController.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/06/10.
//

import UIKit

class SearchViewController: BaseViewController {
    private lazy var searchView = SearchView()
    private lazy var resultView = SearchResultView()
    
    var viewModel: SearchType!
        
    override func setupViews() {
        super.setupViews()
        searchView.delegate = self
        searchView.frame = view.bounds
        searchView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(searchView)
        
        resultView.isHidden = true
        resultView.delegate = self
        resultView.frame = view.bounds
        resultView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(resultView)
    }
    
    override func setupViewModel() {
        super.setupViewModel()
        viewModel.output
            .onRecievedShops
            .observe(onQueue: .main) { [weak self] shops in
                self?.resultView.updateShops(shops)
            }
    }
}

extension SearchViewController: SearchViewDelegate {
    func searchViewClose(_ searchView: SearchView) {
        viewModel.input.dismiss()
    }
    
    func searchView(_ searchView: SearchView, didSearch text: String) {
        viewModel.input.search(keyword: text)
        resultView.keyword = text
        resultView.isHidden = false
        view.bringSubviewToFront(resultView)
    }
}


extension SearchViewController: SearchResultViewDelegate {
    func searchResultViewEdit() {
        view.bringSubviewToFront(searchView)
    }
    
    func searchResultViewNagigateToFilter() {
        viewModel.input.navigateToFilter()
    }
    
    func searchResultViewNagigateToSort() {
        viewModel.input.navigateToSort()
    }
    
    func searchResultViewDismiss() {
        viewModel.input.dismiss()
    }
}
