//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import UIKit
import Foundation
import CommonCrypto

extension NSAttributedString {
    // swiftlint:disable operator_whitespace
    static func +(lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let partOne = NSMutableAttributedString(attributedString: lhs)
        let partTwo = NSMutableAttributedString(attributedString: rhs)
        let combination = NSMutableAttributedString()
        combination.append(partOne)
        combination.append(partTwo)
        return combination
    }

    static func attributedString(string: String,
                                 lineHeight: CGFloat = 15,
                                 font: UIFont = .systemFont(ofSize: 11),
                                 textAlign: NSTextAlignment = .left,
                                 textColor: UIColor = UIColor.black) -> NSAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [:]
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.lineSpacing = 1.3
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.alignment = textAlign
        attributes[.paragraphStyle] = paragraphStyle
        attributes[.foregroundColor] = textColor
        attributes[.font] = font
        let attString = NSAttributedString(string: string, attributes: attributes)
        return attString
    }
}

extension String {
    /**
     :name:    trim
     */
    public var trimmed: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    /**
     :name:    lines
     */
    public var lines: [String] {
        return components(separatedBy: CharacterSet.newlines)
    }

    /**
     :name:    firstLine
     */
    public var firstLine: String? {
        return lines.first?.trimmed
    }

    /**
     :name:    lastLine
     */
    public var lastLine: String? {
        return lines.last?.trimmed
    }

    /**
     :name:    replaceNewLineCharater
     */
    public func replaceNewLineCharater(separator: String = " ") -> String {
        return components(separatedBy: CharacterSet.whitespaces).joined(separator: separator).trimmed
    }

    /**
     :name:    replacePunctuationCharacters
     */
    public func replacePunctuationCharacters(separator: String = "") -> String {
        return components(separatedBy: CharacterSet.punctuationCharacters).joined(separator: separator).trimmed
    }
    
    func trimmedQuote() -> String {
        var value = self
        if value.hasSuffix("\n") { value = String(value.dropLast()) }
        if value.hasPrefix("\""), value.hasSuffix("\"") {
            value = String(value.dropFirst().dropLast())
        }
        return value
    }

    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }

    func isValidPassword() -> Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,15}"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: self)
    }

    func isValidUserName() -> Bool {
        let userNameRegEx = "^[a-zA-Z0-9_.]*${8}"
        let userNamePred = NSPredicate(format: "SELF MATCHES %@", userNameRegEx)
        return userNamePred.evaluate(with: self)
    }

    func convertStringToDate(formatter: String = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = formatter
        return dateFormatter.date(from: self)
    }
}

// Defines types of hash string outputs available
public enum HashOutputType {
    // standard hex string output
    case hex
    // base 64 encoded string output
    case base64
}

// Defines types of hash algorithms available
public enum HashType {
    case md5
    case sha1
    case sha224
    case sha256
    case sha384
    case sha512

    var length: Int32 {
        switch self {
        case .md5: return CC_MD5_DIGEST_LENGTH
        case .sha1: return CC_SHA1_DIGEST_LENGTH
        case .sha224: return CC_SHA224_DIGEST_LENGTH
        case .sha256: return CC_SHA256_DIGEST_LENGTH
        case .sha384: return CC_SHA384_DIGEST_LENGTH
        case .sha512: return CC_SHA512_DIGEST_LENGTH
        }
    }
}

extension String {
    
    func toDate(withFormat type: DateFormatter.FormatType, dateFormatter: DateFormatter = .withUTCTimeZone()) -> Date? {
        let dateFormatter: DateFormatter = dateFormatter
        dateFormatter.dateFormat = type.rawValue
        return dateFormatter.date(from: self)
    }
}
