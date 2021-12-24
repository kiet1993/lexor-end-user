//
//  ThirdPartyView.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. on 5/23/21.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import AuthenticationServices

protocol ThirdPartyStackViewDelegate: AnyObject {
    func view(_ view: ThirdPartyStackView, needsPerform action: ThirdPartyStackView.Action)
}

final class ThirdPartyStackView: UIStackView {
    
    enum Action {
        case didTap(_ type: ThirdPartyType)
    }
    
    enum ThirdPartyType {
        case guest, google, facebook, apple
        
        var title: String {
            switch self {
            case .guest: return "Continue as Guest"
            case .google: return "Continue with Google"
            case .facebook: return "Continue with Facebook"
            case .apple: return "Continue with Apple"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .guest:
                return UIImage(named: "ic-person")
            case .google:
                return UIImage(named: "ic-google")
            case .facebook:
                return UIImage(named: "ic-facebook")
            case .apple:
                if #available(iOS 13.0, *) {
                    return UIImage(systemName: "applelogo")
                } else {
                    return nil
                }
            }
        }
        
        var titleColor: UIColor {
            switch self {
            case .guest, .google: return .gray
            case .facebook: return .white
            case .apple: return .white
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .guest, .google: return .white
            case .facebook: return #colorLiteral(red: 0.2470588235, green: 0.3176470588, blue: 0.7098039216, alpha: 1)
            case .apple: return .black
            }
        }
    }
    
    weak var delegate: ThirdPartyStackViewDelegate?
    var height: CGFloat {
        CGFloat(arrangedSubviews.count * 44 + (arrangedSubviews.count - 1) * 10)
    }
    
    private let signInConfiguration = GIDConfiguration(clientID: Config.googleClientId)
    private var controller: UIViewController!
    private let fbLoginButton: FBLoginButton = FBLoginButton()
    
    func configure(in controller: UIViewController) {
        self.controller = controller
        
        let guestButton = makeDefaultButton(type: .guest)
        guestButton.addTarget(self, action: #selector(guestButtonTouchUpInside), for: .touchUpInside)
        addArrangedSubview(guestButton)
        
        let googleButton = makeDefaultButton(type: .google)
        googleButton.addTarget(self, action: #selector(googleButtonTouchUpInside), for: .touchUpInside)
        addArrangedSubview(googleButton)
        
        let facebookButton = makeDefaultButton(type: .facebook)
        facebookButton.addTarget(self, action: #selector(facebookButtonTouchUpInside), for: .touchUpInside)
        addArrangedSubview(facebookButton)
        
        if #available(iOS 13.0, *) {
            let appleButton = makeDefaultButton(type: .apple)
            appleButton.addTarget(self, action: #selector(appleButtonTouchUpInside), for: .touchUpInside)
            addArrangedSubview(appleButton)
        }
    }
    
    private func makeDefaultButton(type: ThirdPartyType) -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 0.5
        let title = NSAttributedString(
            string: type.title,
            attributes: [
                .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                .foregroundColor: type.titleColor
            ]
        )
        button.setAttributedTitle(title, for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = type.backgroundColor
        button.setImage(type.image, for: .normal)
        button.tintColor = .white
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        return button
    }
    
    @objc private func guestButtonTouchUpInside(_ sender: UIControl) {
        delegate?.view(self, needsPerform: .didTap(.guest))
    }
    
    @objc private func googleButtonTouchUpInside(_ sender: UIControl) {
        GIDSignIn.sharedInstance.signIn(with: signInConfiguration, presenting: controller) { user, error in
            print(user, error)
        }
    }
    
    @objc private func facebookButtonTouchUpInside(_ sender: UIControl) {
        fbLoginButton.delegate = self
        fbLoginButton.permissions = ["public_profile", "email"]
        fbLoginButton.sendActions(for: .touchUpInside)
    }
    
    @available(iOS 13.0, *)
    @objc private func appleButtonTouchUpInside(_ sender: UIControl) {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension ThirdPartyStackView: LoginButtonDelegate {
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) { }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print(error)
        } else if let token = AccessToken.current, !token.isExpired {
            let token = token.tokenString
            let request = FBSDKLoginKit.GraphRequest(
                graphPath: "me",
                parameters: ["fields": "email, name"],
                tokenString: token,
                version: nil,
                httpMethod: .get
            )
            request.start(completion: { (_, result, _) in
                guard let result = result as? [String: Any],
                      let id = result["id"] as? String  else { return }
                print(id)
            })
        }
    }
}

@available(iOS 13.0, *)
extension ThirdPartyStackView: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.controller.view.window.unwrapped(or: UIWindow())
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            print(credential)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        guard let error = error as? ASAuthorizationError else {
            return
        }
        print(error.code)
    }
}
