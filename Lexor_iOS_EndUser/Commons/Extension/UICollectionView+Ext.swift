//
//  UICollectionView+Ext.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. VN.Danang on 6/3/21.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(_ aClass: T.Type, bundle bundleOrNil: Bundle? = nil) {
        let identifier: String = String(describing: aClass)
        if Bundle.main.path(forResource: identifier, ofType: "nib") != nil {
            let nib: UINib = UINib(nibName: identifier, bundle: bundleOrNil)
            register(nib, forCellWithReuseIdentifier: identifier)
        } else {
            register(aClass, forCellWithReuseIdentifier: identifier)
        }
    }

    func register<T: UICollectionReusableView>(_ kind: String, _ aClass: T.Type, bundle bundleOrNil: Bundle? = nil) {
        let identifier: String = String(describing: aClass)
        if Bundle.main.path(forResource: identifier, ofType: "nib") != nil {
            let nib: UINib = UINib(nibName: identifier, bundle: bundleOrNil)
            register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
        } else {
            register(aClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
        }
    }

    func dequeue<T: UICollectionViewCell>(_ aClass: T.Type, at indexPath: IndexPath) -> T {
        let identifier: String = String(describing: aClass)
        guard let cell: T = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("\(identifier) is not registered")
        }
        return cell
    }

    func dequeue<T: UICollectionReusableView>(_ kind: String, _ aClass: T.Type, at indexPath: IndexPath) -> T {
        let identifier: String = String(describing: aClass)
        guard let view: T = dequeueReusableSupplementaryView(ofKind: kind,
                                                             withReuseIdentifier: identifier,
                                                             for: indexPath) as? T else {
            fatalError("\(identifier) is not registered")
        }
        return view
    }
}
