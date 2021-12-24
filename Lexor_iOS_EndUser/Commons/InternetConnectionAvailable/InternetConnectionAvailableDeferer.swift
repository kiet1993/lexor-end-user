//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import UIKit
import Network
import Reachability

protocol DeferItem: AnyObject {
    func run()
}

protocol InternetConnectionAvailableDefererType {
    func addItem(handler: @escaping () -> Void) -> DeferItem
    func removeItem(_ item: DeferItem)
    func addItem(item: DeferItem)
}

private class InternetDeferItem: DeferItem {
    var handler: () -> Void
    init(handler: @escaping () -> Void) {
        self.handler = handler
    }
    func run() {
        handler()
    }
}

class InternetConnectionAvailableDeferer: InternetConnectionAvailableDefererType {
    lazy var reachability = try? Reachability()

    let application = UIApplication.shared
    fileprivate var items: [DeferItem] = []

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundNotification(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDidEnterBackgroundNotification(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    @objc
    func willEnterForegroundNotification(_ sender: Notification) {
        guard !items.isEmpty else { return }
        try? reachability?.startNotifier()
    }

    @objc
    func handleDidEnterBackgroundNotification(_ sender: Notification) {
        guard !items.isEmpty else { return }
        reachability?.stopNotifier()
    }

    func addItem(handler: @escaping () -> Void) -> DeferItem {
        let item = InternetDeferItem(handler: handler)
        addItem(item: item)
        return item
    }

    func addItem(item: DeferItem) {
        items.append(item)
        if items.count == 1 {
            guard let reachability = reachability else { return }
            reachability.whenReachable = { closureReachability in
                guard reachability.connection != .unavailable else { return }
                let willHandleItems = self.items
                self.items = []
                willHandleItems.forEach { $0.run() }
                DispatchQueue.main.async { reachability.stopNotifier() }
            }
            if application.applicationState != .background {
                do {
                    try reachability.startNotifier()
                } catch let exception {
                    print("reachability startNotifier failure: " + exception.localizedDescription)
                }
            }
        }
    }

    func removeItem(_ item: DeferItem) {
        items = items.filter({$0 !== item})
        if items.isEmpty {
            if let reachability = reachability {
                reachability.stopNotifier()
                reachability.whenReachable = nil
            }
        }
    }
}
