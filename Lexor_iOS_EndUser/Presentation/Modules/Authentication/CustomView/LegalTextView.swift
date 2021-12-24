//
//  LegalTextView.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. on 5/23/21.
//

import UIKit

final class LegalTextView: UITextView {
    
    private let content: String = "By continuing, you agree to Lexor's \(LegalType.terms.title) and acknowledge Lexor's \(LegalType.policy.title)."
    var textHandler: ((LegalType) -> Void)?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        prepare()
    }
    
    private func prepare() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 2.5
        let attributedText: NSMutableAttributedString = NSMutableAttributedString(
            string: content,
            attributes: [
                .font: UIFont.systemFont(ofSize: 10),
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.gray
            ]
        )
        LegalType.allCases.forEach {
            let range = (content as NSString).range(of: $0.title)
            let attrs: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.systemTeal,
                NSAttributedString.Key(rawValue: $0.title): "\($0.rawValue)"
            ]
            attributedText.addAttributes(attrs, range: range)
        }
        self.attributedText = attributedText
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTextAction(_:)))
        addGestureRecognizer(recognizer)
    }
    
    @objc private func handleTextAction(_ recognizer: UITapGestureRecognizer) {
        LegalType.allCases.forEach { type in
            recognizer.findAttributedValue(for: type.title) { value in
                guard value == type.rawValue, let type = LegalType(rawValue: value) else { return }
                self.textHandler?(type)
            }
        }
    }
}
