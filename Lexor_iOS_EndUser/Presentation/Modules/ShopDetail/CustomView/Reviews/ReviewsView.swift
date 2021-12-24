//
//  ReviewsView.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. VN.Danang on 6/29/21.
//

import UIKit

protocol ReviewsViewDelegate: AnyObject {
    func view(_ view: ReviewsView, needsPerform action: ReviewsView.Action)
}

final class ReviewsView: UIView {
    
    private struct Constants {
        static let tableInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    enum Action {
        case writeReview
    }
    
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var ratingView: RatingView!
    @IBOutlet private weak var totalReviewsLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    weak var delegate: ReviewsViewDelegate?
    var viewModel: ReviewsViewModel? {
        didSet {
            update()
        }
    }
    
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
        tableView.register(ReviewCell.self)
        tableView.dataSource = self
        tableView.contentInset = Constants.tableInset
    }
    
    private func commonInit() {
        if let view = Bundle.main.loadNibNamed("ReviewsView", owner: self)?.first as? UIView {
            addSubview(view)
            view.snp.makeConstraints { $0.edges.equalToSuperview() }
        }
    }
    
    private func update() {
        guard let viewModel = viewModel else { return }
        let ratingString = "\(viewModel.rating)/5"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributedText = NSMutableAttributedString(
            string: ratingString,
            attributes: [
                .font: UIFont.systemFont(ofSize: 18.0, weight: .bold),
                .foregroundColor: UIColor.darkGray
            ]
        )
        let range = (ratingString as NSString).range(of: "/5")
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 12.0, weight: .regular)]
        attributedText.addAttributes(attrs, range: range)
        
        ratingLabel.attributedText = attributedText
        ratingView.rating = viewModel.rating
        totalReviewsLabel.text = viewModel.totalReviews
        tableView.reloadData()
    }
    
    @IBAction private func writeReviewButtonTouchUpInside(_ sender: UIButton) {
        delegate?.view(self, needsPerform: .writeReview)
    }
}

extension ReviewsView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfRows(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        let cell = tableView.dequeue(ReviewCell.self, indexPath: indexPath)
        cell.viewModel = viewModel.viewModelForRow(at: indexPath)
        return cell
    }
}
