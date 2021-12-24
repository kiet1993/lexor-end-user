//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import Foundation

protocol ConfigType {
    var endPoint: String { get }
    var version: String { get }
}

private func readProperty<T>(key: Config.AppConfigKeys, plist: [String: Any]) -> T {
    guard let value = plist[key.rawValue] as? T else {
        fatalError("Missing or invalid key \(key) in Config.plist")
    }
    return value
}

private func readOptionalProperty<T>(key: Config.AppConfigKeys, plist: [String: Any]) -> T? {
    if plist.keys.contains(key.rawValue) {
        if let valueT = plist[key.rawValue] as? T {
            return valueT
        } else {
            fatalError("Invalid key: \(key.rawValue) in Config.plist")
        }
    }
    return nil
}

struct Config: ConfigType {

    fileprivate enum AppConfigKeys: String {
        case endPoint = "END_POINT"
        case apiVersion = "API_VERSION"
    }

    private var configs: [String: Any]!
    private var appVersion: String!

    init() {
        guard
            let currentConfiguration = Bundle.main.infoDictionary?["Configuration"] as? String,
            let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
            let configDictionary = NSDictionary(contentsOfFile: path)?.object(forKey: currentConfiguration) as? [String: Any]
            else {
                //TODO: Load default case instead
                fatalError("Cannot load Config Environment!!!")
        }

        self.configs = configDictionary

        if let currentAppVersion = Bundle.main.infoDictionary?["Bundle version"] as? String {
            appVersion = currentAppVersion
        }
    }

    // MARK: Config values
    var endPoint: String {
        return readProperty(key: .endPoint, plist: configs)
    }
    
    var apiVersion: String {
        return readProperty(key: .apiVersion, plist: configs)
    }

    var version: String {
        return appVersion
    }
}

extension Config {
    
    static let googleClientId: String = forceCast(value["GOOGLE_CLIENT_ID"])
    static let googleAPIKey: String = forceCast(value["GOOGLE_API_KEY"])
    
    private static let value: [String: Any] = {
        guard let file = Bundle.main.url(forResource: "Config", withExtension: "plist") else {
            fatalError("Missing Config.plist file in Application bundle")
        }
        guard let configuration = Bundle.main.infoDictionary?["Configuration"] as? String else {
            fatalError("Cannot load Configuration")
        }
        guard let value = NSDictionary(contentsOf: file)?.object(forKey: configuration) as? [String: Any] else {
            fatalError("Config.plist content is wrong format")
        }
        return value
    }()
}

private func forceCast<T>(_ valueOrNil: Any?) -> T {
    guard let value = valueOrNil as? T else {
        fatalError("Cannot cast value '\(String(describing: valueOrNil))' to type '\(T.self)'")
    }
    return value
}
