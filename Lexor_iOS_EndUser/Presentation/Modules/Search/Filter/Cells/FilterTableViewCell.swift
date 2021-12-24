//
//  FilterTableViewCell.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/06/30.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var radioButton: UIButton!
    
    override func prepareForReuse() {
        isSelected = false
    }
    
    override var isSelected: Bool {
        didSet {
            radioButton.isSelected = isSelected
        }
    }
    
    func bind(title: String) {
        titleLabel.text = title
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        radioButton.isSelected = isSelected
    }
}
