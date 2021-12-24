//
//  ServicesView.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. VN.Danang on 6/3/21.
//

import UIKit

protocol ServicesViewDelegate: AnyObject {
    func view(_ view: ServicesView, needsPerform action: ServicesView.Action)
}

final class ServicesView: UIView {
    
    enum Action {
        case didSelectService(_ service: Service)
    }
    
    private struct Constants {
        static let tableInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    
    private var dispatchWorkItem: DispatchWorkItem?
    
    var viewModel: ServicesViewModel? {
        didSet {
            update()
        }
    }
    
    weak var delegate: ServicesViewDelegate?
    
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
        textField.addDoneButtonOnKeyboard()
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        tableView.register(ServiceCell.self)
        tableView.dataSource = self
        tableView.contentInset = Constants.tableInset
    }
    
    private func commonInit() {
        if let view = Bundle.main.loadNibNamed("ServicesView", owner: self)?.first as? UIView {
            addSubview(view)
            view.snp.makeConstraints { $0.edges.equalToSuperview() }
        }
    }
    
    @objc private func textFieldEditingChanged(_ sender: UITextField) {
        guard let viewModel = viewModel else { return }
        let keyword = sender.text.orEmpty
        dispatchWorkItem?.cancel()
        let dispatchWorkItem = DispatchWorkItem { [weak self] in
            guard let this = self else { return }
            viewModel.search(for: keyword, completion: {
                this.tableView.reloadData()
            })
        }
        self.dispatchWorkItem = dispatchWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: dispatchWorkItem)
    }
    
    private func update() {
        textField.text = ""
        tableView.reloadData()
    }
    
    @IBAction private func searchButtonTouchUpInside(_ sender: UIButton) {
        textField.becomeFirstResponder()
    }
}

extension ServicesView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfRows(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        let cell = tableView.dequeue(ServiceCell.self, indexPath: indexPath)
        cell.viewModel = viewModel.viewModelForRow(at: indexPath)
        cell.delegate = self
        return cell
    }
}

extension ServicesView: ServiceCellDelegate {
    func cell(_ cell: ServiceCell, needPerformAction action: ServiceCell.Action) {
        switch action {
        case .bookItem(let service):
            delegate?.view(self, needsPerform: .didSelectService(service))
        }
    }
}
