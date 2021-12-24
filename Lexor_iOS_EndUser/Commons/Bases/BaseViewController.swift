//
//  BaseViewController.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/05/24.
//

import UIKit

class BaseViewController: UIViewController {

    var isNeedBackBarButton: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupViewModel()
        setCustomtBackBarButton()
    }
    
    func setupViews() {}
    
    func setupViewModel() {}

    func setCustomtBackBarButton() {
        guard isNeedBackBarButton else { return }
        self.navigationItem.setHidesBackButton(true, animated:false)
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        button.setImage(UIImage(named: "ic_common_back"), for: .normal)
        button.tintColor = .black.withAlphaComponent(0.2)
        button.addShadow(ofColor: .white, radius: 3,
                         offset: CGSize(width: 0, height: 0),
                         opacity: 1)
        let backTap = UITapGestureRecognizer(target: self, action: #selector(popToPreviousVC))
        button.addGestureRecognizer(backTap)

        let leftBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }

    @objc func popToPreviousVC() {
        self.navigationController?.popViewController(animated: true)
    }

    deinit {
        print("Deinit 📣: \(String(describing: self))")
    }
}
