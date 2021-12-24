//
//  TechnicianView.swift
//  Lexor_iOS_EndUser
//
//  Created by Harosc on 10/23/21.
//

import UIKit
import SnapKit
import SDWebImage

final class TechnicianView: UIView {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.cornerRadius = 28
    }
    
    func update(technician: Technician) {
        imageView.sd_setImage(with: URL(string: technician.imageURL), placeholderImage: UIImage(named: "ic-person.large"))
        nameLabel.text = technician.name
    }
    
    private func commonInit() {
        if let view = Bundle.main.loadNibNamed("TechnicianView", owner: self)?.first as? UIView {
            addSubview(view)
            view.snp.makeConstraints { $0.edges.equalToSuperview() }
        }
    }
}
