//
//  BaseCoordinator.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/05/23.
//

import UIKit

protocol Presentable {
    func childTransitionCompleted()
    var viewController: UIViewController { get }
}

extension Presentable {
    func childTransitionCompleted() {}
}

extension UIViewController: Presentable {
    var viewController: UIViewController {
        return self
    }
}

protocol Coordinator: AnyObject {
    func start()
    func finish()
    func addChild(_ coordinator: Coordinator)
    func removeChild(_ coordinator: Coordinator)
    func removeAllChild<T>(with type: T.Type)
    func removeAllChild()
    func removeFromParent()
    var parentCoordinator: Coordinator? { get set }
    var rootNavigationController: UINavigationController { get set }
}

class BaseCoordinator: NSObject, Coordinator, Presentable {
    var rootNavigationController: UINavigationController
    var parentCoordinator: Coordinator?
    private(set) var children: [Coordinator] = []
    
    init(rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
        super.init()
    }
    
    func start() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }
    
    func finish() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }
    
    func removeFromParent() {
        parentCoordinator?.removeChild(self)
    }

    func addChild(_ coordinator: Coordinator) {
        for element in children where element === coordinator {
            return
        }
        
        children.append(coordinator)
        registerParent(coordinator)
    }
    
    func registerParent(_ coordinator: Coordinator) {
        coordinator.parentCoordinator = self
    }

    func removeChild(_ coordinator: Coordinator) {
        if let index = children.firstIndex(where: { $0 === coordinator }) {
            children.remove(at: index)
        } else {
            print("Couldn't remove coordinator: \(coordinator). It's not a child coordinator.")
        }
    }
    
    func removeAllChild<T>(with type: T.Type) {
        children.removeAll(where: { $0 is T })
    }

    func removeAllChild() {
        children.removeAll()
    }
    
    var viewController: UIViewController {
        return rootNavigationController
    }
        
    deinit {
        debugPrint("Deinit 📣: \(String(describing: self))")
    }
}

extension BaseCoordinator {
    func present(_ presentable: Presentable, animated: Bool = true,
                 modalPresentationStyle: UIModalPresentationStyle = .fullScreen,
                 completion: (() -> Void)? = nil) {
        presentable.viewController.modalPresentationStyle = modalPresentationStyle
        rootNavigationController.present(presentable.viewController, animated: animated, completion: completion)
    }
    
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        rootNavigationController.dismiss(animated: animated, completion: completion)
    }
    
    func push(_ presentable: Presentable, animated: Bool = true, hidesBottomBarWhenPushed: Bool = false) {
        let controller = presentable.viewController
        guard controller is UINavigationController == false else {
            return
        }
        controller.hidesBottomBarWhenPushed = hidesBottomBarWhenPushed
        rootNavigationController.pushViewController(controller, animated: animated)
    }
    
    func pop(animated: Bool = true)  {
        rootNavigationController.popViewController(animated: animated)
    }
    
    func setRoot(_ presentable: Presentable, animated: Bool = true) {
        rootNavigationController.setViewControllers([presentable.viewController], animated: animated)
    }
    
    func setRoot(_ presentables: [Presentable], animated: Bool = true) {
        rootNavigationController.setViewControllers(presentables.map({ $0.viewController }), animated: animated)
    }
}
