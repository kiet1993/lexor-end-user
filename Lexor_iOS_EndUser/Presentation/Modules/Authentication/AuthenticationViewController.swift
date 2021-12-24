//
//  AuthenticationViewController.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. on 5/23/21.
//

import UIKit

protocol AuthenticationViewControllerDelegate: AnyObject {
    func controller(_ controller: AuthenticationViewController, needsPerform action: AuthenticationViewController.Action)
}

final class AuthenticationViewController: BaseViewController {
    
    enum Action {
        case update
        case cancel
    }
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var legalTextView: LegalTextView!
    @IBOutlet private var textFields: [UITextField]!
    @IBOutlet private weak var lineView: UIView!
    @IBOutlet private weak var errorView: UIView!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var thirdPartyStackView: ThirdPartyStackView!
    @IBOutlet private weak var thirdPartyStackViewHeightConstant: NSLayoutConstraint!
    @IBOutlet private weak var signupTextView: UITextView!
    
    private let viewModel: AuthenticationViewModel
    lazy final private var rightBarButtonItem: UIBarButtonItem = { [unowned self] in
        return UIBarButtonItem(
            title: screen.barTitle,
            style: .plain,
            target: self,
            action: #selector(rightBarButtonTouchUpInside)
        )
    }()
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    let screen: AuthenticationScreen
    weak var delegate: AuthenticationViewControllerDelegate?
    
    init(screen: AuthenticationScreen) {
        self.screen = screen
        viewModel = AuthenticationViewModel(screen: screen)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        validateData()
    }
    
    private func configure() {
        title = "Lexor"
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Back",
            style: .plain,
            target: self,
            action: nil
        )
        navigationItem.rightBarButtonItem = rightBarButtonItem
        rightBarButtonItem.isEnabled = false
        
        stackView.arrangedSubviews.forEach {
            if let field = AuthenticationField(rawValue: $0.tag) {
                $0.isHidden = !screen.fields.contains(field)
            }
        }
        
        legalTextView.textHandler = { [unowned self] type in
            self.view.endEditing(true)
            let vc = LegalViewController()
            vc.type = type
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        textFields.forEach { textField in
            if screen == .login, textField.tag == AuthenticationField.password.rawValue {
                textField.returnKeyType = .done
            }
            if textField.tag == AuthenticationField.country.rawValue {
                textField.inputView = pickerView
                textField.text = viewModel.countries[safe: viewModel.countrySelectedIndex]?.emoji
            }
            textField.addDoneButtonOnKeyboard()
            textField.delegate = self
            textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        }
        
        lineView.isHidden = screen == .login
        
        thirdPartyStackView.configure(in: self)
        thirdPartyStackView.delegate = self
        thirdPartyStackViewHeightConstant.constant = thirdPartyStackView.height
        
        let signupString = "Don't have a Lexor Account? Sign up"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributedText: NSMutableAttributedString = NSMutableAttributedString(
            string: signupString,
            attributes: [
                .font: UIFont.systemFont(ofSize: 15),
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.darkGray
            ]
        )
        let range = (signupString as NSString).range(of: "Sign up")
        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemTeal,
            NSAttributedString.Key(rawValue: "Sign up"): "0"
        ]
        attributedText.addAttributes(attrs, range: range)
        signupTextView.attributedText = attributedText
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTextAction(_:)))
        signupTextView.addGestureRecognizer(recognizer)
    }
    
    @objc private func rightBarButtonTouchUpInside(_ sender: UIBarButtonItem) {
        switch screen {
        case .login:
            login()
        case .signup:
            signup()
        }
    }
    
    @objc private func textFieldEditingChanged(_ sender: UITextField) {
        guard let field = AuthenticationField(rawValue: sender.tag) else { return }
        switch field {
        case .first:
            viewModel.firstName = sender.text.orEmpty
        case .last:
            viewModel.lastName = sender.text.orEmpty
        case .mobile:
            viewModel.mobile = sender.text.orEmpty
        case .email:
            viewModel.email = sender.text.orEmpty
        case .password:
            viewModel.password = sender.text.orEmpty
        case .confirm:
            viewModel.confirm = sender.text.orEmpty
        case .postalcode:
            viewModel.postalcode = sender.text.orEmpty
        default:
            break
        }
    }
    
    @objc private func handleTextAction(_ recognizer: UITapGestureRecognizer) {
        recognizer.findAttributedValue(for: "Sign up") { value in
            guard value == 0 else { return }
            view.endEditing(true)
            let vc = AuthenticationViewController(screen: .signup)
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func validateData() {
        viewModel.validateWhenValueChanged = { [weak self] in
            guard let this = self else { return }
            this.loginButton.isEnabled = false
            this.loginButton.alpha = 0.5
            this.rightBarButtonItem.isEnabled = false
            do {
                try this.viewModel.validate()
                this.loginButton.isEnabled = true
                this.loginButton.alpha = 1
                this.rightBarButtonItem.isEnabled = true
                this.errorView.isHidden = true
            } catch {
                guard let error = error as? AuthenticationError else { return }
                this.errorLabel.text = error.localizedDescription
                this.errorView.isHidden = false
            }
        }
    }
    
    private func login() {
        view.endEditing(true)
        HUD.show()
        viewModel.login { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            switch result {
            case .success:
                this.delegate?.controller(this, needsPerform: .update)
            case .failure(let error):
                this.showError(error)
            }
        }
    }
    
    private func signup() {
        view.endEditing(true)
        HUD.show()
        viewModel.signup { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            switch result {
            case .success:
                this.delegate?.controller(this, needsPerform: .update)
            case .failure(let error):
                this.showError(error)
            }
        }
    }
    
    @IBAction private func countryButtonTouchUpInside(_ sender: UIButton) {
        if let textField = textFields.first(where: { $0.tag == AuthenticationField.country.rawValue }) {
            textField.becomeFirstResponder()
        }
    }
    
    @IBAction private func forgotButtonTouchUpInside(_ sender: UIButton) {
        view.endEditing(true)
        let vc = ForgotPasswordViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func loginButtonTouchUpInside(_ sender: UIButton) {
        login()
    }
}

extension AuthenticationViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let field = AuthenticationField(rawValue: textField.tag) else { return }
        switch field {
        case .password:
            if viewModel.password != textField.text {
                viewModel.password = textField.text.orEmpty
            }
        case .confirm:
            if viewModel.confirm != textField.text {
                viewModel.confirm = textField.text.orEmpty
            }
        case .country:
            guard viewModel.countries.indices.contains(viewModel.countrySelectedIndex) else { return }
            pickerView.selectRow(viewModel.countrySelectedIndex, inComponent: 0, animated: false)
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .done {
            textField.resignFirstResponder()
        } else if let field = AuthenticationField(rawValue: textField.tag + 1), screen.fields.contains(field) {
            if let next = textFields.first(where: { $0.tag == textField.tag + 1 }) {
                next.becomeFirstResponder()
            }
        }
        return true
    }
}

extension AuthenticationViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.countries.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.countries[safe: row]?.name
    }
}

extension AuthenticationViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let textField = textFields.first(where: { $0.tag == AuthenticationField.country.rawValue }) else { return }
        textField.text = viewModel.countries[safe: row]?.emoji
        viewModel.countrySelectedIndex = row
    }
}

extension AuthenticationViewController: AuthenticationViewControllerDelegate {
    
    func controller(_ controller: AuthenticationViewController, needsPerform action: Action) {
        guard controller.screen == .signup else { return }
        delegate?.controller(self, needsPerform: action)
    }
}

extension AuthenticationViewController: ThirdPartyStackViewDelegate {
    
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
