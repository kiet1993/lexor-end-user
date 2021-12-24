//
//  Dymanic.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/07/15.
//

import Foundation

class BehaviorDynamic<T> {
    typealias Listener = (T) -> Void
    private var listener: Listener?
    private var queue: DispatchQueue = DispatchQueue.global()
    
    func observe(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    func observe(onQueue queue: DispatchQueue, _ listener: Listener?) {
        self.queue = queue
        self.listener = listener
        queue.async {
            listener?(self.value)
        }
    }
    
    var value: T {
        didSet {
            queue.async {
                self.listener?(self.value)
            }
        }
    }
    
    func onEvent(_ value: T) {
        self.value = value
    }
    
    init(value: T) {
        self.value = value
    }
}

class PublishDynamic<T> {
    typealias Listener = (T) -> Void
    private var listener: Listener?
    
    private var queue: DispatchQueue = DispatchQueue.global()
    
    func observe(_ listener: Listener?) {
        self.listener = listener
    }
    
    func observe(onQueue queue: DispatchQueue, _ listener: Listener?) {
        self.queue = queue
        self.listener = listener
    }
    
    func onEvent(_ value: T) {
        queue.async {
            self.listener?(value)
        }
    }
}
