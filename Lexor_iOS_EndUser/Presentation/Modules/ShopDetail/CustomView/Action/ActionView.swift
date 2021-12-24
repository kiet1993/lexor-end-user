//
//  ActionView.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. VN.Danang on 6/30/21.
//

import UIKit

final class ActionView: UIStackView {
    
    enum Action: Int {
        case favourite = 0, comment, share
    }
    
    @IBOutlet private weak var favouriteButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func commonInit() {
        if let view = Bundle.main.loadNibNamed("ActionView", owner: self)?.first as? UIStackView {
            addSubview(view)
            view.snp.makeConstraints { $0.edges.equalToSuperview() }
        }
    }
    
    func updateFavourite(_ value: Bool) {
        favouriteButton.isSelected = value
    }
    
    @IBAction private func actionButtonTouchUpInside(_ sender: UIButton) {
        guard let action = Action(rawValue: sender.tag) else { return }
        print(action)
        sender.isSelected = !sender.isSelected
    }
}
