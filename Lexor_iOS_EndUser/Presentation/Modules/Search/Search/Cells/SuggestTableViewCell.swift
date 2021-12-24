//
//  SuggestTableViewCell.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/06/11.
//

import UIKit

class SuggestTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bind(title: String) {
        titleLabel.text = title
    }
}
