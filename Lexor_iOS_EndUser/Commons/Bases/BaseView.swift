//
//  BaseView.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/06/11.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }

    private func commonInit() {
        guard Bundle.main.path(forResource: className, ofType: "nib") != nil else {
            // file not exists
            return
        }
        guard let contentView = Bundle.main.loadNibNamed(className, owner: self, options: nil)?.first as? UIView else {
            return
        }
        contentView.frame = bounds
        addSubview(contentView)
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    func setupUI() { }
    func setupLayout() { }

    deinit {
        print("Deinit 📣: \(String(describing: self))")
    }
}
