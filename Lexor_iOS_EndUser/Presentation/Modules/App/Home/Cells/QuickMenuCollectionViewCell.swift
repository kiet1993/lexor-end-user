//
//  QuickMenuCollectionViewCell.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/06/03.
//

import UIKit

class QuickMenuCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var quickMenuView: QuickMenuView!

    func bind(type: QuickMenuType) {
        quickMenuView.type = type
    }
}
