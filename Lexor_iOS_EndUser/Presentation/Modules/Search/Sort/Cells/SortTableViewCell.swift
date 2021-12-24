//
//  SortTableViewCell.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/06/30.
//

import UIKit

class SortTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var radioButton: UIButton!
    @IBOutlet private weak var separatorView: UIView!
    
    override var isSelected: Bool {
        didSet {
            radioButton.isSelected = isSelected
        }
    }
    
    func bind(title: String, isDisabledSeparator: Bool) {
        titleLabel.text = title
        separatorView.isHidden = isDisabledSeparator
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        radioButton.isSelected = isSelected
    }
    
}
