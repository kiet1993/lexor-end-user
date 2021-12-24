//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import UIKit
import SnapKit

extension NSObject {
    static var className: String {
        return String(describing: self)
    }

    var className: String {
        return type(of: self).className
    }
}

extension UITableView {
    func isNoResults(_ isNoResult: Bool, iconNoData: UIImage = #imageLiteral(resourceName: "icon-no-data-food"), content: String = "") {
        if isNoResult {
            let emptyView = UIView(frame: bounds)
            emptyView.backgroundColor = .clear
            let imageView = UIImageView()
            imageView.image = iconNoData
            imageView.contentMode = .scaleAspectFill
            let contentNoDataLabel = UILabel()

            contentNoDataLabel.text = content
            contentNoDataLabel.font = UIFont.basHeadingMedium(ofSize: 14)
            contentNoDataLabel.textColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
            contentNoDataLabel.textAlignment = .center
            contentNoDataLabel.numberOfLines = 0
            emptyView.addSubview(imageView)
            emptyView.addSubview(contentNoDataLabel)

            imageView.snp.makeConstraints { (make) -> Void in
                make.centerY.equalTo(emptyView).offset(-20)
                make.centerX.equalTo(emptyView)
                make.height.equalTo(32)
                make.width.equalTo(32)
            }

            contentNoDataLabel.snp.makeConstraints { (make) -> Void in
                make.centerX.equalTo(imageView)
                make.top.equalTo(imageView.snp_bottomMargin).offset(16)
                make.leading.equalTo(emptyView.snp_leadingMargin).offset(10)
                make.trailing.equalTo(emptyView.snp_trailingMargin).offset(-10)
            }

            backgroundView = emptyView
        } else {
            backgroundView = nil
        }
    }
    
    func register<T: UITableViewCell>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        let bundle = Bundle.main
        if bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forCellReuseIdentifier: name)
        } else {
            register(aClass, forCellReuseIdentifier: name)
        }
    }

    func register<T: UITableViewHeaderFooterView>(_ aClass: T.Type) {
        let name = aClass.className
        let bundle = Bundle.main
        if bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forHeaderFooterViewReuseIdentifier: name)
        } else {
            register(aClass, forHeaderFooterViewReuseIdentifier: name)
        }
    }

    func dequeue<T: UITableViewCell>(_ aClass: T.Type) -> T {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withIdentifier: name) as? T else {
            fatalError("`\(name)` is not registed")
        }
        return cell
    }
    func dequeueH<T: UITableViewHeaderFooterView>(_ aClass: T.Type) -> T {
        let name = aClass.className
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: name) as? T else {
            fatalError("`\(name)` is not registed")
        }
        return cell
    }
    

    func dequeue<T: UITableViewHeaderFooterView>(_ aClass: T.Type) -> T {
        let name = aClass.className
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: name) as? T else {
            fatalError("`\(name)` is not registed")
        }
        return cell
    }

    func cellAtIndexPath<T: UITableViewCell>(_ type: T.Type, indexPath: IndexPath) -> T? {
        return cellForRow(at: indexPath) as? T
    }
}

extension UITableView {
    
    func register<T: UITableViewCell>(_ aClass: T.Type, bundle bundleOrNil: Bundle? = nil) {
        let identifier: String = String(describing: aClass)
        if Bundle.main.path(forResource: identifier, ofType: "nib") != nil {
            let nib: UINib = UINib(nibName: identifier, bundle: bundleOrNil)
            register(nib, forCellReuseIdentifier: identifier)
        } else {
            register(aClass, forCellReuseIdentifier: identifier)
        }
    }

    func dequeue<T: UITableViewCell>(_ aClass: T.Type, indexPath: IndexPath) -> T {
        let identifier: String = String(describing: aClass)
        guard let cell: T = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("\(identifier) is not registered")
        }
        return cell
    }
}
