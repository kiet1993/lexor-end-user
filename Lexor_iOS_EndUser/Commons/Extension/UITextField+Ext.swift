//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import UIKit

extension UITextField {
    func setUpTextFieldWithLoginStyle(font: UIFont, placeholder: String, keyboardType: UIKeyboardType, borderColor: UIColor = UIColor.bas40, widthRightView: CGFloat = 40, widthLeftView: CGFloat = 19) {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: widthLeftView, height: self.frame.size.height))
        self.leftView = leftView
        self.leftViewMode = .always
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = borderColor.cgColor
        self.backgroundColor = UIColor.basWhite
        self.keyboardType = keyboardType
        self.font = font
        self.placeholder = placeholder
        self.clearButtonMode = .whileEditing
    }
    
    func addDoneButtonOnKeyboard() {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTouchUpInside))
        toolbar.items = [space, done]
        toolbar.sizeToFit()
        inputAccessoryView = toolbar
    }

    @objc func doneButtonTouchUpInside(_ sender: UIBarButtonItem) {
        resignFirstResponder()
    }
}
