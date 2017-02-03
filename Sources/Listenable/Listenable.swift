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
    
    public typealias ListenerUpdate = (_ listener: T,_ index: Int) -> Void
    
    // MARK: Properties
    
    lazy private var listeners = [ListenerNode<T>]()
    
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
    /// - Paramter priority: Enumeration positional priority of the listener.
    /// - Returns: Whether the listener was successfully added.
    @discardableResult public func add(listener: T,
                                       priority: ListenerPriority = .low) -> Bool {
        if self.index(ofListener: listener) == nil {
            
            let insertionIndex = self.insertionIndex(forListenerWithPriority: priority)
            let node = ListenerNode(value: listener,
                                    priority: priority.value)
            self.listeners.insert(node, at: insertionIndex)
            
            return true
        }
        return false
    }
    
    /// Add a number of new listeners to the Listenable object.
    ///
    /// - Parameter listeners: The new listeners to add.
    /// - Paramter priority: Enumeration positional priority of the listeners.
    public func add(listeners: [T],
                    priority: ListenerPriority = .low) -> Void {
        for listener in listeners {
            self.add(listener: listener, priority: priority)
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
    
    
    /// Update the registered listeners of the Listener object.
    ///
    /// - parameter priority: The exclusive priority of listeners to update.
    /// - parameter update:   Update execution closure for each listener.
    public func updateListeners(withPriority priority: ListenerPriority,
                                _ update: ListenerUpdate) -> Void {
        let value = priority.value
        self.updateListeners(withPriorities: value...value, update)
    }
    
    /// Update the registered listeners of the Listener object.
    ///
    /// - Parameter priorities: The range of listener priorities to update.
    /// - Parameter update: Update execution closure for each listener.
    public func updateListeners(withPriorities priorities: ClosedRange<Int>? = nil,
                                _ update: ListenerUpdate) -> Void {
        
        var listenersToRemove = [ListenerNode<T>]()
        
        for (index, listenerWrapper) in self.listeners.enumerated() {
            guard let listener = listenerWrapper.value as? T else {
                listenersToRemove.append(listenerWrapper)
                continue
            }
            
            if let priorities = priorities { // evaluate whether listener has required priority
                guard priorities.contains(listenerWrapper.priority) else {
                    continue
                }
                
                update(listener, index)
                
            } else { // no priority restriction
                update(listener, index)
            }
        }
        // clean up any listeners which have been destroyed
        self.listeners = self.listeners.filter {
            value in !listenersToRemove.contains(where: {$0 === value})
        }
    }
    
    /// Check whether an object is a registered listener.
    ///
    /// - parameter object: The object to check.
    ///
    /// - returns: Whether the object is a listener.
    public func isListener(_ object: T) -> Bool {
        return self.index(ofListener: object) != nil
    }
    
    // MARK: Private
    
    private func index(ofListener listener: T) -> Int? {
        let index = self.listeners.index { (wrapper) -> Bool in
            return wrapper.value === listener as AnyObject
        }
        return index
    }
    
    private func insertionIndex(forListenerWithPriority priority: ListenerPriority) -> Int {
        var insertionIndex: Int?
        
        if priority != .low {
            
            // enumerate until we find position where priority is less than desired
            let priorityValue = priority.value
            for (index, listener) in self.listeners.enumerated() {
                if listener.priority < priorityValue {
                    insertionIndex = index
                    break
                }
            }
        }
        
        if let insertionIndex = insertionIndex {
            return insertionIndex
        }
        
        return self.listeners.count
    }
}
