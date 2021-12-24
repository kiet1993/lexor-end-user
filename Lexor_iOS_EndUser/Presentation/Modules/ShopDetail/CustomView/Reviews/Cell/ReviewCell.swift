//
//  ReviewCell.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. VN.Danang on 6/30/21.
//

import UIKit

final class ReviewCell: UITableViewCell {
    
    @IBOutlet private weak var ratingView: RatingView!
    @IBOutlet private weak var reviewerLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    
    
    var viewModel: ReviewCellViewModel? {
        didSet {
            update()
        }
    }
    
    private func update() {
        guard let viewModel = viewModel else { return }
        ratingView.rating = viewModel.rating
        reviewerLabel.text = viewModel.reviewer
        dateLabel.text = viewModel.dateString
        contentLabel.text = viewModel.content
    }
}
