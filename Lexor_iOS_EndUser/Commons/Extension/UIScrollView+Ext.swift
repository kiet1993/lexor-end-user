//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import UIKit

extension UIScrollView {

    func scrollToBottom(animated: Bool) {
        var bottomOffset = CGPoint.zero
        if self.contentSize.height < self.bounds.size.height {
            bottomOffset = CGPoint(x: 0, y: self.bounds.size.height - self.contentSize.height)
        } else {
            bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        }

        self.setContentOffset(bottomOffset, animated: animated)
    }

    func scrollToTop(animated: Bool = true) {
        var offset = CGPoint(x: -contentInset.left.rounded(),
                             y: -contentInset.top.rounded())

        if #available(iOS 11.0, *) {
            offset = CGPoint(x: -adjustedContentInset.left.rounded(),
                             y: -adjustedContentInset.top.rounded())
        }

        setContentOffset(offset, animated: animated)
    }

    var isContentAtTop: Bool {
        if #available(iOS 11.0, *) {
            return contentOffset.y.rounded() == -adjustedContentInset.top.rounded()
        } else {
            return contentOffset.y.rounded() == -contentInset.top.rounded()
        }
    }

    var minContentOffset: CGPoint {
        return CGPoint(
            x: -contentInset.left,
            y: -contentInset.top)
    }

    var maxContentOffset: CGPoint {
        return CGPoint(
            x: contentSize.width - bounds.width + contentInset.right,
            y: contentSize.height - bounds.height + contentInset.bottom)
    }

    func scrollToEnd(animated: Bool) {
        setContentOffset(maxContentOffset, animated: animated)
    }
}
