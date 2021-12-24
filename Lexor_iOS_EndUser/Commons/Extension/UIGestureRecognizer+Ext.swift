//
//  UIGestureRecognizer+Ext.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. on 5/23/21.
//

import UIKit

extension UIGestureRecognizer {
    
    func findAttributedValue(for rawValue: String, completion: (Int) -> Void) {
        guard let textView = view as? UITextView,
            let attributedText = textView.attributedText else { return }

        let layoutManager = textView.layoutManager
        var location = self.location(in: textView)
        location.x -= textView.textContainerInset.left
        location.y -= textView.textContainerInset.top

        let characterIndex = layoutManager.characterIndex(
            for: location,
            in: textView.textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
        if characterIndex < textView.textStorage.length {
            let attrName: NSAttributedString.Key = NSAttributedString.Key(rawValue: rawValue)
            if let stringValue = attributedText.attribute(attrName, at: characterIndex, effectiveRange: nil) as? String,
                let value = Int(stringValue) {
                completion(value)
            }
        }
    }
}
