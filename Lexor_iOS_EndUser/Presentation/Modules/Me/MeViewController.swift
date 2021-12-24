//
//  MeViewController.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. on 5/23/21.
//

import UIKit

protocol MeViewControllerDelegate: AnyObject {
    func controller(_ controller: MeViewController, needsPerform action: MeViewController.Action)
}

final class MeViewController: UIViewController {
    
    enum Action {
        case cancel
    }
    
    weak var delegate: MeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update()
    }
    
    private func update() {
        if AccountManager.shared.shouldLogin {
            view.isHidden = true
            let vc = DashboardAuthenticationViewController()
            vc.delegate = self
            let nc = UINavigationController(rootViewController: vc)
            nc.modalPresentationStyle = .overFullScreen
            present(nc, animated: true)
        } else {
            view.isHidden = false
        }
    }
    
    @IBAction private func logoutButtonTouchUpInside(_ sender: UIButton) {
        AccountManager.shared.token = nil
        delegate?.controller(self, needsPerform: .cancel)
    }
}

extension MeViewController: DashboardAuthenticationViewControllerDelegate {
    
    func controller(_ controller: DashboardAuthenticationViewController, needsPerform action: DashboardAuthenticationViewController.Action) {
        switch action {
        case .cancel:
            delegate?.controller(self, needsPerform: .cancel)
        case .update:
            update()
        }
        dismiss(animated: true)
    }
}
