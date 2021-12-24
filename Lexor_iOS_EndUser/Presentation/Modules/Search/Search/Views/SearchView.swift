//
//  SearchView.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/06/10.
//

import UIKit

protocol SearchViewDelegate: AnyObject {
    func searchView(_ searchView: SearchView, didSearch text: String)
    func searchViewClose(_ searchView: SearchView)
}

class SearchView: BaseView {
    //MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var locationSearchView: UIView!
    @IBOutlet private weak var textSearchView: UIView!
    @IBOutlet private weak var searchTextField: UITextField!
    
    var suggestedKeywords: [String] = [
        "Nails", "Delivery", "Beauty", "Accountants", "Spa", "Store"
    ]
    
    weak var delegate: SearchViewDelegate?
    
    override func setupUI() {
        [textSearchView, locationSearchView].forEach {
            $0?.cornerRadius = ($0?.bounds.height ?? 0) / 2
            $0?.borderColor = .lightGray
            $0?.borderWidth = 0.5
        }
        
        tableView.register(SuggestTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        
        searchTextField.delegate = self
    }
    
    @IBAction private func back() {
        delegate?.searchViewClose(self)
    }
}

extension SearchView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.searchView(self, didSearch: textField.text ?? "")
    }
}

extension SearchView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        suggestedKeywords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SuggestTableViewCell.self)
        cell.bind(title: suggestedKeywords[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        55
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchTextField.text = suggestedKeywords[indexPath.row]
        delegate?.searchView(self, didSearch: suggestedKeywords[indexPath.row])
    }
}
