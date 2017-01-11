//
//  ListenableTests.swift
//  ListenableTests
//
//  Created by Merrick Sapsford on 10/01/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import XCTest
@testable import Listenable

class ListenableTests: XCTestCase {
    
    // Mark: Constants
    
    let maxListenerCount: UInt32 = 25
    
    // MARK: Properties
    
    var listenableObject: TestListenableObject!
    var currentTestListeners: [TestListener]?
    
    // MARK: Lifecycle
    
    override func setUp() {
        super.setUp()
        
        self.listenableObject = TestListenableObject()
    }
    
    // MARK: Tests
    
    func testAddListener() {
        let initialListenerCount = self.listenableObject.listenerCount
        self.addTestListeners(count: 1, toListenableObject: self.listenableObject)
        
        XCTAssert(self.listenableObject.listenerCount == initialListenerCount + 1,
                  "Listener was not added successfully")
    }
    
    func testAddMultipleListeners() {
        let proposedListenerCount = Int(arc4random_uniform(maxListenerCount) + 1)
        self.addTestListeners(count: proposedListenerCount,
                              toListenableObject: self.listenableObject)
        
        XCTAssert(self.listenableObject.listenerCount == proposedListenerCount,
                  "Multiple listeners were not added successfully")
    }
    
    func testRemoveListener() {
        let listeners = self.addTestListeners(count: 1,
                                              toListenableObject: self.listenableObject)
        let addedCount = self.listenableObject.listenerCount
        
        if let listener = listeners.first {
            self.listenableObject.remove(listener: listener)
        }
        
        XCTAssert((self.listenableObject.listenerCount == addedCount - 1) && addedCount != 0,
                  "Listener was not removed successfully")
    }
    
    func testRemoveListeners() {
        let proposedListenerCount = Int(arc4random_uniform(maxListenerCount) + 1)
        let listeners = self.addTestListeners(count: proposedListenerCount,
                                              toListenableObject: self.listenableObject)
        let addedCount = self.listenableObject.listenerCount
        
        self.listenableObject.remove(listeners: listeners)
        
        XCTAssert((self.listenableObject.listenerCount == (proposedListenerCount - listeners.count)) && addedCount != 0,
                  "Multiple listeners were not removed successfully")
    }
    
    func testRemoveAllListeners() {
        let proposedListenerCount = Int(arc4random_uniform(maxListenerCount) + 1)
        self.addTestListeners(count: proposedListenerCount,
                              toListenableObject: self.listenableObject)
        let addedCount = self.listenableObject.listenerCount

        self.listenableObject.removeAllListeners()
        
        XCTAssert((addedCount != 0) && self.listenableObject.listenerCount == 0,
                  "All listeners were not removed successfully")
    }
    
    func testEnumerateAllListeners() {
        let proposedListenerCount = Int(arc4random_uniform(maxListenerCount) + 1)
        self.addTestListeners(count: proposedListenerCount,
                              toListenableObject: self.listenableObject)
        let listenerCount = self.listenableObject.listenerCount
        
        var evaluatedListenerCount = 0
        var finalIndex = 0
        self.listenableObject.updateListeners { (listener, index) in
            evaluatedListenerCount += 1
            finalIndex = index
        }
        
        XCTAssert((evaluatedListenerCount == listenerCount) && (finalIndex == listenerCount - 1),
                  "Not all listeners were enumerated through")
    }
    
    func testEnumerateDestroyedListeners() {
        // add listeners
        var destroyableListener: TestListener? = TestListener()
        let retainedListener = TestListener()
        self.listenableObject.add(listeners: [destroyableListener!, retainedListener])
        let addedListenerCount = self.listenableObject.listenerCount
        
        // destroy
        destroyableListener = nil
        
        // enumerate
        var evaluatedListenerCount = 0
        self.listenableObject.updateListeners { (listener, index) in
            evaluatedListenerCount += 1
        }
        let postEnumerationCount = self.listenableObject.listenerCount
        
        XCTAssert((evaluatedListenerCount == 1) && (addedListenerCount == 2) && (postEnumerationCount == addedListenerCount - 1),
                  "Destroyed listeners are not being removed during the enumeration operation successfully")
    }
    
    // MARK: Utils
    
    @discardableResult func addTestListeners(count: Int,
                                             toListenableObject listenableObject: TestListenableObject) -> [TestListener] {
        var listeners = [TestListener]()
        for _ in 1...count {
            listeners.append(TestListener())
        }
        
        listenableObject.add(listeners: listeners)
        self.currentTestListeners = listeners
        return listeners
    }
}
