//
//  ReviewCellViewModel.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. VN.Danang on 7/14/21.
//

import Foundation

final class ReviewCellViewModel {
    
    private let review: Review
    
    init(review: Review) {
        self.review = review
    }
    
    var rating: Double {
        if let first = review.ratings.first {
            return first.percent * 5 / 100
        }
        return 0
    }
    
    var dateString: String {
        if let date = review.createdDate {
            return date.toString(withFormat: .dMsYSpace)
        }
        return "--"
    }
    
    var reviewer: String {
        return review.nickname.orEmpty
    }
    
    var content: String {
        return review.detail.orEmpty
    }
    
}
