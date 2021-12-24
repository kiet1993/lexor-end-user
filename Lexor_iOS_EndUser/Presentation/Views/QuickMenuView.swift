//
//  QuickMenu.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/05/25.
//

import UIKit
import SnapKit

class QuickMenuView: UIView {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    var type: QuickMenuType = .vouchers {
        didSet {
            imageView.image = type.image
            titleLabel.text = type.title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        imageView.image = type.image
        titleLabel.text = type.title
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        titleLabel.textColor = .lightGray
        
        addSubview(imageView)
        imageView.snp.makeConstraints { maker in
            maker.width.height.equalTo(35)
            maker.top.equalToSuperview()
            maker.centerX.equalToSuperview()
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { maker in
            maker.bottom.left.right.equalToSuperview()
        }
    }
}
