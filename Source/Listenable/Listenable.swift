//
//  Listenable.swift
//  Listenable
//
//  Created by Merrick Sapsford on 10/01/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import Foundation


/// An object which can have a number of listeners for delegation.
open class Listenable<T>: AnyObject {
    
    // MARK: Closures
    
    public typealias ListenerEnumeration = (_ listener: T,_ index: Int) -> Void
    
    // MARK: Properties
    
    lazy private var listeners = [ListenableNode<T>]()
    
    /// The number of currently active listeners.
    var listenerCount: Int {
        get {
            return self.listeners.count
        }
    }
    
    // MARK: Init
    
    public init() {
        // Empty init
    }
    
    // MARK: Public
    
    /// Add a new listener to the Listenable object.
    ///
    /// - Parameter listener: The new listener to add.
    /// - Returns: Whether the listener was successfully added.
    @discardableResult public func add(listener: T) -> Bool {
        if self.index(ofListener: listener) == nil {
            self.listeners.append(ListenableNode(value: listener))
            return true
        }
        return false
    }
    
    /// Add a number of new listeners to the Listenable object.
    ///
    /// - Parameter listeners: The new listeners to add.
    public func add(listeners: [T]) -> Void {
        for listener in listeners {
            self.add(listener: listener)
        }
    }
    
    /// Remove a listener from the Listenable object.
    ///
    /// - Parameter listener: The listener to remove.
    /// - Returns: Whether the listener was successfully removed.
    @discardableResult public func remove(listener: T) -> Bool {
        guard let index = self.index(ofListener: listener) else {
            return false
        }
        
        self.listeners.remove(at: index)
        return true
    }
    
    /// Remove a number of listeners from the Listenable object.
    ///
    /// - Parameter listeners: The listeners to remove.
    public func remove(listeners: [T]) -> Void {
        for listener in listeners {
            self.remove(listener: listener)
        }
    }
    
    /// Remove all listeners from the Listenable object.
    public func removeAllListeners() -> Void {
        self.listeners.removeAll()
    }
    
    
    /// Enumerate through all the listeners of the Listener object.
    ///
    /// - Parameter enumerateBlock: Execution block for each listener.
    public func enumerate(_ enumerateBlock: ListenerEnumeration) -> Void {
        var indexesToRemove = [Int]()
        
        for (index, listenerWrapper) in self.listeners.enumerated() {
            if let listener = listenerWrapper.value as? T {
                enumerateBlock(listener, index)
            } else {
                indexesToRemove.append(index)
            }
        }
        
        // clean up any listeners which have been destroyed
        for removalIndex in indexesToRemove {
            self.listeners.remove(at: removalIndex)
        }
    }
    
    // MARK: Private
    
    private func index(ofListener listener: T) -> Int? {
        let index = self.listeners.index { (wrapper) -> Bool in
            return wrapper.value === listener as AnyObject
        }
        return index
    }
}
