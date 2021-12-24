//
//  LegalViewController.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. on 5/23/21.
//

import UIKit
import WebKit

enum LegalType: Int, CaseIterable {
    case terms = 0, policy
    
    var title: String {
        switch self {
        case .terms: return "Terms of Service"
        case .policy: return "Privacy Policy"
        }
    }
    
    var urlString: String {
        return "https://www.google.com.vn/"
    }
}

final class LegalViewController: UIViewController {
    
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.isHidden = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    private var observation: NSKeyValueObservation?
    var type: LegalType?
    
    deinit {
        observation?.invalidate()
        observation = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        title = "Loading..."
        activityIndicatorView.startAnimating()
        view.addSubview(webView)
        webView.snp.makeConstraints { $0.edges.equalToSuperview() }
        guard let type = type, let url = URL(string: type.urlString) else { return }
        observation = webView.observe(\.isLoading, options: [.new]) { [weak self] (_, change) in
            guard let this = self, let value = change.newValue else { return }
            this.webView.isHidden = value
            this.title = value ? "Loading..." : type.title
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
