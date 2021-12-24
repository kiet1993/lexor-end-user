//
//  ReviewsViewModel.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. VN.Danang on 6/30/21.
//

import Foundation

final class ReviewsViewModel {
    
    private let output: ShopDetailViewModel.Output
    
    init(output: ShopDetailViewModel.Output) {
        self.output = output
    }
    
    var totalReviews: String {
        return "based on \(output.reviewsCount) reviews"
    }
    
    var rating: Double {
        return 0.0
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        output.reviews.count
    }
    
    func viewModelForRow(at indexPath: IndexPath) -> ReviewCellViewModel? {
        guard let review = output.reviews[safe: indexPath.row] else { return nil }
        return ReviewCellViewModel(review: review)
    }
}
