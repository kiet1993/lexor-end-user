//
//  ServiceListVC.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 6/8/21.
//

import UIKit

protocol ServiceListVCDelegate: AnyObject {
    func controller(_ controller: ServiceListVC, needPerformAcion action: ServiceListVC.Action)
}

final class ServiceListVC: BaseViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var servicesView: ServicesView!

    // MARK: - Properties
    enum Action {
        case selectedService(_ serviceInfo: Service)
    }

    var viewModel = ServiceListVM(serviceList: [])
    weak var delegate: ServiceListVCDelegate?

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        getData()
    }

    // MARK: - Private
    private func getData() {
        servicesView.viewModel = viewModel.viewModelForServicesView()
        servicesView.delegate = self
    }

    private func configUI() {

    }
}

extension ServiceListVC: ServicesViewDelegate {
    func view(_ view: ServicesView, needsPerform action: ServicesView.Action) {
        switch action {
        case .didSelectService(let serviceInfo):
            delegate?.controller(self, needPerformAcion: .selectedService(serviceInfo))
            navigationController?.popViewController(animated: true)
        }
    }
}
