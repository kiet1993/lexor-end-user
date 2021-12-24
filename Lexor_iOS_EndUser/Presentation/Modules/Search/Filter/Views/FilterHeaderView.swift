//
//  FilterHeaderView.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/06/30.
//

import UIKit

class FilterHeaderView: UITableViewHeaderFooterView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var separatorView: UIView!
    
    override func awakeFromNib() {
        contentView.backgroundColor = .white
    }
    
    func bind(title: String, isDisabledSeparator: Bool) {
        titleLabel.text = title
        separatorView.isHidden = isDisabledSeparator
    }
}
