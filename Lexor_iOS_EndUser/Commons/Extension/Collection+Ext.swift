//
//  Collection+Ext.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. on 5/23/21.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        if indices.contains(index) {
            return self[index]
        }
        return nil
    }
}
