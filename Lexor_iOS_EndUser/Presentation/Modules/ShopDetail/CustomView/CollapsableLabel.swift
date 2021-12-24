//
//  CollapsableLabel.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. VN.Danang on 7/3/21.
//

import UIKit

typealias LineIndexTuple = (line: CTLine, index: Int)

class CollapsableLabel: UILabel {
    
    enum ReplacementType {
        case character
        case word
    }
    
    var originText: NSAttributedString? {
        didSet {
            if let originText = originText, originText.length > 0 {
                self.collapsedText = getCollapsedText(for: originText, link: collapsedLink)
                self.expandedText = getExpandedText(for: originText, link: expandedLink)
                attributedText = isCollapsed ? collapsedText : expandedText
            } else {
                self.expandedText = nil
                self.collapsedText = nil
                attributedText = nil
            }
        }
    }
    var isCollapsed: Bool = true {
        didSet {
            super.attributedText = isCollapsed ? collapsedText : expandedText
            super.numberOfLines = isCollapsed ? collapsedNumberOfLines : 0
        }
    }
    var collapsedLink: NSAttributedString!
    var expandedLink: NSAttributedString!
    var ellipsis: NSAttributedString!
    var replacementType: ReplacementType = .word
    
    private var collapsedText: NSAttributedString?
    private var expandedText: NSAttributedString?
    private var collapsedLinkRange: NSRange?
    private var expandedLinkRange: NSRange?
    private var collapsedNumberOfLines: NSInteger = 0
    
    override var numberOfLines: NSInteger {
        didSet {
            collapsedNumberOfLines = numberOfLines
        }
    }
    override var text: String? {
        set(text) {
            if let text = text {
                originText = NSAttributedString(string: text)
            } else {
                originText = nil
            }
        }
        get {
            return attributedText?.string
        }
    }
    override var bounds: CGRect {
        didSet {
            originText = originText?.copy() as? NSAttributedString
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    public init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touch = touches.first else { return }
        let linkRange: NSRange? = isCollapsed ? collapsedLinkRange : expandedLinkRange
        guard let range = linkRange else { return }
        if didTouchLink(with: touch, in: range) {
            isCollapsed = !isCollapsed
            setNeedsDisplay()
        }
    }
    
    private func commonInit() {
        isUserInteractionEnabled = true
        lineBreakMode = .byClipping
        collapsedNumberOfLines = numberOfLines
        let linkAttrs: [NSAttributedString.Key: Any] = [
            .font: font as Any,
            .foregroundColor: textColor.withAlphaComponent(0.5)
        ]
        expandedLink = NSAttributedString(string: "Less", attributes: linkAttrs)
        collapsedLink = NSAttributedString(string: "See more", attributes: linkAttrs)
        ellipsis = NSAttributedString(string: "...")
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func getCollapsedText(for text: NSAttributedString, link: NSAttributedString) -> NSAttributedString {
        let lines = text.lines(for: frame.size.width)
        if collapsedNumberOfLines > 0 && collapsedNumberOfLines < lines.count {
            let lastLine = lines[collapsedNumberOfLines - 1] as CTLine
            let lineIndex: LineIndexTuple = (lastLine, collapsedNumberOfLines - 1)
            var modifiedLastLineText: NSAttributedString
            if replacementType == .character {
                modifiedLastLineText = textReplaceCharacterWithLink(lineIndex: lineIndex, text: text, link: link)
            } else {
                modifiedLastLineText = textReplaceWordWithLink(lineIndex: lineIndex, text: text, link: link)
            }
            let collapsedText = NSMutableAttributedString()
            for index in 0..<lineIndex.index {
                collapsedText.append(text.text(for: lines[index]))
            }
            collapsedText.append(modifiedLastLineText)
            collapsedLinkRange = NSRange(location: collapsedText.length - link.length, length: link.length)
            return collapsedText
        }
        return text
    }
    
    private func getExpandedText(for text: NSAttributedString, link: NSAttributedString) -> NSAttributedString {
        let expandedText = NSMutableAttributedString()
        expandedText.append(text)
        if textWillBeTruncated(expandedText) {
            expandedText.append(NSMutableAttributedString(string: " \(link.string)", attributes: link.attributes(at: 0, effectiveRange: nil)))
            expandedLinkRange = NSRange(location: expandedText.length - link.length, length: link.length)
        }
        return expandedText
    }
    
    private func textReplaceCharacterWithLink(lineIndex: LineIndexTuple, text: NSAttributedString, link: NSAttributedString) -> NSAttributedString {
        let lineText = text.text(for: lineIndex.line)
        let lineTextTrimmedNewLines = NSMutableAttributedString()
        lineTextTrimmedNewLines.append(lineText)
        let nsString = lineTextTrimmedNewLines.string as NSString
        let range = nsString.rangeOfCharacter(from: CharacterSet.newlines)
        if range.length > 0 {
            lineTextTrimmedNewLines.replaceCharacters(in: range, with: "")
        }
        let linkText = NSMutableAttributedString()
        linkText.append(ellipsis)
        linkText.append(NSAttributedString(string: " ", attributes: [.font: font as Any]))
        linkText.append(link)
        var deletedCharacters = 0
        repeat {
            let length = lineTextTrimmedNewLines.length - deletedCharacters
            let truncatedText = lineTextTrimmedNewLines.attributedSubstring(from: NSRange(location: 0, length: length))
            
            if !truncatedText.string.hasSuffix(" ") {
                let lineTextWithLink = NSMutableAttributedString(attributedString: truncatedText)
                lineTextWithLink.append(linkText)
                if textFitsWidth(lineTextWithLink) {
                    return lineTextWithLink
                }
            }
            deletedCharacters += 1
        } while deletedCharacters < lineText.length
        lineTextTrimmedNewLines.append(linkText)
        return lineTextTrimmedNewLines
    }
    
    private func textReplaceWordWithLink(lineIndex: LineIndexTuple, text: NSAttributedString, link: NSAttributedString) -> NSAttributedString {
        var lineText = text.text(for: lineIndex.line)
        let linkText = NSMutableAttributedString()
        linkText.append(ellipsis)
        linkText.append(NSAttributedString(string: " ", attributes: [.font: font as Any]))
        linkText.append(link)
        while lineText.string.hasSuffix(" ") {
            lineText = lineText.attributedSubstring(from: NSRange(location: 0, length: lineText.length - 1))
        }
        var lineTextWithLink = NSMutableAttributedString(attributedString: lineText)
        lineTextWithLink.append(linkText)
        if textFitsWidth(lineTextWithLink) {
            return lineTextWithLink
        }
        (lineText.string as NSString).enumerateSubstrings(
            in: NSRange(location: 0, length: lineText.length),
            options: [.byWords, .reverse],
            using: { (_, subRange, _, stop) in
                var lineTextWithLastWordRemoved = lineText.attributedSubstring(from: NSRange(location: 0, length: subRange.location))
                while lineTextWithLastWordRemoved.string.hasSuffix(" ") {
                    lineTextWithLastWordRemoved = lineTextWithLastWordRemoved.attributedSubstring(from: NSRange(location: 0, length: lineTextWithLastWordRemoved.length - 1))
                }
                let lineTextWithAddedLink = NSMutableAttributedString(attributedString: lineTextWithLastWordRemoved)
                lineTextWithAddedLink.append(linkText)
                if self.textFitsWidth(lineTextWithAddedLink) {
                    lineTextWithLink = lineTextWithAddedLink
                    stop.pointee = true
                }
            }
        )
        return lineTextWithLink
    }
    
    private func textFitsWidth(_ text: NSAttributedString) -> Bool {
        var lineHeightMultiple: CGFloat = 1
        var lineSpacing: CGFloat = 1
        for index in 0..<text.length {
            if let style = text.attribute(NSAttributedString.Key.paragraphStyle, at: index, effectiveRange: nil) as? NSParagraphStyle {
                lineHeightMultiple = max(lineHeightMultiple, style.lineHeightMultiple)
                lineSpacing = max(lineHeightMultiple, style.lineSpacing)
            }
        }
        return (text.boundingRect(for: frame.size.width).size.height <= font.lineHeight * lineHeightMultiple + lineSpacing) as Bool
    }
    
    private func textWillBeTruncated(_ text: NSAttributedString) -> Bool {
        let lines = text.lines(for: frame.size.width)
        return collapsedNumberOfLines > 0 && collapsedNumberOfLines < lines.count
    }
    
    private func didTouchLink(with touch: UITouch, in range: NSRange) -> Bool {
        let touchPoint = touch.location(in: self)
        let index = touchedIndex(at: touchPoint)
        return NSLocationInRange(index, range)
    }

    private func touchedIndex(at touchedPoint: CGPoint) -> Int {
        guard let attributedString = attributedText else { return NSNotFound }
        guard bounds.contains(touchedPoint) else { return NSNotFound }
        let textRect = textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        guard textRect.contains(touchedPoint) else { return NSNotFound }
        var point = touchedPoint
        point = CGPoint(x: point.x - textRect.origin.x, y: point.y - textRect.origin.y)
        point = CGPoint(x: point.x, y: textRect.size.height - point.y)
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        let suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, attributedString.length), nil, CGSize(width: textRect.width, height: CGFloat.greatestFiniteMagnitude), nil)
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: suggestedSize.width, height: CGFloat(ceilf(Float(suggestedSize.height)))))
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attributedString.length), path, nil)
        let lines = CTFrameGetLines(frame)
        let linesCount = numberOfLines > 0 ? min(numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines)
        if linesCount == 0 { return NSNotFound }
        var lineOrigins = [CGPoint](repeating: .zero, count: linesCount)
        CTFrameGetLineOrigins(frame, CFRangeMake(0, linesCount), &lineOrigins)
        for (idx, lineOrigin) in lineOrigins.enumerated() {
            var lineOrigin = lineOrigin
            let lineIndex = CFIndex(idx)
            let line = unsafeBitCast(CFArrayGetValueAtIndex(lines, lineIndex), to: CTLine.self)
            var ascent: CGFloat = 0.0
            var descent: CGFloat = 0.0
            var leading: CGFloat = 0.0
            let width = CGFloat(CTLineGetTypographicBounds(line, &ascent, &descent, &leading))
            let yMin = CGFloat(floor(lineOrigin.y - descent))
            let yMax = CGFloat(ceil(lineOrigin.y + ascent))
            let flushFactor = flushFactorForTextAlignment(textAlignment: textAlignment)
            let penOffset = CGFloat(CTLineGetPenOffsetForFlush(line, flushFactor, Double(textRect.size.width)))
            lineOrigin.x = penOffset
            if point.y > yMax { return NSNotFound }
            if point.y >= yMin && point.x >= lineOrigin.x && point.x <= lineOrigin.x + width {
                let relativePoint = CGPoint(x: point.x - lineOrigin.x, y: point.y - lineOrigin.y)
                return Int(CTLineGetStringIndexForPosition(line, relativePoint))
            }
        }
        return NSNotFound
    }

    private func flushFactorForTextAlignment(textAlignment: NSTextAlignment) -> CGFloat {
        switch textAlignment {
        case .center: return 0.5
        case .right: return 1.0
        case .left, .natural, .justified: return 0.0
        @unknown default: fatalError()
        }
    }
}

private extension NSAttributedString {
    
    func lines(for width: CGFloat) -> [CTLine] {
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        let framesetter = CTFramesetterCreateWithAttributedString(self as CFAttributedString)
        let frame = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: 0), path.cgPath, nil)
        guard let lines = CTFrameGetLines(frame) as? [CTLine] else { return [] }
        return lines
    }
    
    func text(for line: CTLine) -> NSAttributedString {
        let lineRange = CTLineGetStringRange(line)
        let range = NSRange(location: lineRange.location, length: lineRange.length)
        return attributedSubstring(from: range)
    }
    
    func boundingRect(for width: CGFloat) -> CGRect {
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        return boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil)
    }
}
