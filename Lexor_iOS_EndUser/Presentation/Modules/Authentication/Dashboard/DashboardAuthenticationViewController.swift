//
//  DashboardAuthenticationViewController.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. on 5/23/21.
//

import UIKit

protocol DashboardAuthenticationViewControllerDelegate: AnyObject {
    func controller(_ controller: DashboardAuthenticationViewController,
                    needsPerform action: DashboardAuthenticationViewController.Action)
}

final class DashboardAuthenticationViewController: UIViewController {
    
    enum Action {
        case cancel
        case update
    }
    
    @IBOutlet private weak var legalTextView: LegalTextView!
    @IBOutlet private weak var thirdPartyStackView: ThirdPartyStackView!
    @IBOutlet private weak var thirdPartyStackViewHeightConstant: NSLayoutConstraint!
    
    weak var delegate: DashboardAuthenticationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        title = "Lexor"
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelBarButtonTouchUpInside)
        )
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Back",
            style: .plain,
            target: self,
            action: nil
        )
        
        legalTextView.textHandler = { [unowned self] type in
            let vc = LegalViewController()
            vc.type = type
            self.navigationController?.pushViewController(vc, animated: true)
        }
        thirdPartyStackView.configure(in: self)
        thirdPartyStackView.delegate = self
        thirdPartyStackViewHeightConstant.constant = thirdPartyStackView.height
    }
    
    @objc private func cancelBarButtonTouchUpInside(_ sender: UIBarButtonItem) {
        delegate?.controller(self, needsPerform: .cancel)
    }
    
    @IBAction private func loginButtonTouchUpInside(_ sender: UIButton) {
        let vc = AuthenticationViewController(screen: .login)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func signupButtonTouchUpInside(_ sender: UIButton) {
        let vc = AuthenticationViewController(screen: .signup)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DashboardAuthenticationViewController: AuthenticationViewControllerDelegate {
    
    func controller(_ controller: AuthenticationViewController, needsPerform action: AuthenticationViewController.Action) {
        switch action {
        case .update:
            delegate?.controller(self, needsPerform: .update)
        case .cancel:
            delegate?.controller(self, needsPerform: .cancel)
        }
    }
}

extension DashboardAuthenticationViewController: ThirdPartyStackViewDelegate {
    
    func view(_ view: ThirdPartyStackView, needsPerform action: ThirdPartyStackView.Action) {
        switch action {
        case .didTap(let type):
            switch type {
            case .guest:
                delegate?.controller(self, needsPerform: .cancel)
            default:
                break
            }
        }
    }
}
