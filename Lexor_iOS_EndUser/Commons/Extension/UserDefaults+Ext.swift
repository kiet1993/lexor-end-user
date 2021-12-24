//
//  UserDefaults+Ext.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. VN.Danang on 6/8/21.
//

import Foundation

/// - Must not modify when using
/// - Just modify when writing tests. Mock UserDefault before modifying value.
///
/// Note: Define variable to can be easily modified when testing.
///
public var userDefaults: UserDefaults = .standard

extension UserDefaults {
    
    var keys: Dictionary<String, Any>.Keys {
        return dictionaryRepresentation().keys
    }

    subscript<T: Any>(key: Key, defaultValue: T) -> T {
        get { return self[key.rawValue, defaultValue] }
        set { self[key.rawValue] = newValue }
    }
    
    subscript<T: Any>(key: Key) -> T? {
        get { return self[key.rawValue] }
        set { self[key.rawValue] = newValue }
    }
    
    func remove(key: Key) {
        removeObject(forKey: key.rawValue)
        synchronize()
    }
}

fileprivate extension UserDefaults {
    
    subscript<T: Any>(key: String, defaultValue: T) -> T {
        get {
            (object(forKey: key) as? T).unwrapped(or: defaultValue)
        }
        set {
            set(newValue, forKey: key)
            synchronize()
        }
    }
    
    subscript<T: Any>(key: String) -> T? {
        get {
            return object(forKey: key) as? T
        }
        set {
            guard let newValue = newValue else {
                removeObject(forKey: key)
                return
            }
            set(newValue, forKey: key)
            synchronize()
        }
    }
}
