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
    
    // MARK: Add listeners
    
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
    
    func testAddExistingListenerFail() {
        let listener = self.addTestListeners(count: 1, toListenableObject: self.listenableObject).first!
        let successfulAdd = self.listenableObject.add(listener: listener)
        
        XCTAssert(successfulAdd == false, "Duplicate listener was able to be added")
    }
    
    func testListenerDetection() {
        let listener = self.addTestListeners(count: 1, toListenableObject: self.listenableObject).first!
        
        XCTAssert(self.listenableObject.isListener(listener),
                  "Listeners are not correctly identified as registered")
    }
    
    // MARK: Prioritisation
    
    func testAddHighPriorityListener() {
        let lowPriorityListeners = [TestListener(), TestListener(), TestListener()]
        self.listenableObject.add(listeners: lowPriorityListeners, priority: .low)
        
        let highPriorityListener = TestListener()
        self.listenableObject.add(listener: highPriorityListener, priority: .high)
        
        var initialListener: TestListener!
        self.listenableObject.updateListeners { (listener, index) in
            if let listener = listener as? TestListener, index == 0 {
                initialListener = listener
            }
        }
        
        XCTAssert(initialListener === highPriorityListener,
                  "High priority listener was not correctly inserted at index 0")
    }
    
    func testAddLowPriorityListener() {
        let highPriorityListeners = [TestListener(), TestListener(), TestListener()]
        self.listenableObject.add(listeners: highPriorityListeners, priority: .high)
        
        let lowPriorityListener = TestListener()
        self.listenableObject.add(listener: lowPriorityListener, priority: .low)
        
        var finalListener: TestListener!
        self.listenableObject.updateListeners { (listener, index) in
            if let listener = listener as? TestListener, index == self.listenableObject.listenerCount - 1 {
                finalListener = listener
            }
        }
        
        XCTAssert(finalListener === lowPriorityListener,
                  "Low priority listener was not correctly inserted at end of listener queue")
    }

    func testAddCustomPriorityListener() {
        let highPriorityListeners = [TestListener()]
        self.listenableObject.add(listeners: highPriorityListeners, priority: .high)
        
        let lowPriorityListeners = [TestListener()]
        self.listenableObject.add(listeners: lowPriorityListeners, priority: .low)
        
        let customPriorityListener = TestListener()
        self.listenableObject.add(listener: customPriorityListener, priority: .custom(value: 500))
        
        var middleListener: TestListener!
        self.listenableObject.updateListeners { (listener, index) in
            if let listener = listener as? TestListener,  index == self.listenableObject.listenerCount - lowPriorityListeners.count - 1 {
                middleListener = listener
            }
        }
        
        XCTAssert(middleListener === customPriorityListener,
                  "Custom priority (500) listener was not correctly inserted to the middle of the listener queue")
    }
    
    func testOutOfBoundsMaxPriorityListener() {
        let highPriorityListeners = [TestListener(), TestListener(), TestListener()]
        self.listenableObject.add(listeners: highPriorityListeners, priority: .high)

        let uberHighPrioritylistener = TestListener()
        self.listenableObject.add(listener: uberHighPrioritylistener, priority: .custom(value: 1001))
        
        var lastListener: TestListener!
        self.listenableObject.updateListeners { (listener, index) in
            if let listener = listener as? TestListener, index == self.listenableObject.listenerCount - 1 {
                lastListener = listener
            }
        }
        
        XCTAssert(lastListener === uberHighPrioritylistener,
                  "Listener with out of range 1001 priority was not floored to 1000 and inserted at the end of the high priority queue.")
    }
    
    func testOutOfBoundsMinPriorityListener() {
        let lowPriorityListeners = [TestListener(), TestListener(), TestListener()]
        self.listenableObject.add(listeners: lowPriorityListeners, priority: .low)
        
        let uberLowPrioritylistener = TestListener()
        self.listenableObject.add(listener: uberLowPrioritylistener, priority: .custom(value: -1))
        
        var lastListener: TestListener!
        self.listenableObject.updateListeners { (listener, index) in
            if let listener = listener as? TestListener, index == self.listenableObject.listenerCount - 1 {
                lastListener = listener
            }
        }

        XCTAssert(lastListener === uberLowPrioritylistener,
                  "Listener with out of range -1 priority was not ceiled to 0 and inserted at the end of the low priority queue.")
    }
    
    // MARK: Remove listeners
    
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
    
    func testRemoveNonExistentListenerFail() {
        let listener = self.addTestListeners(count: 1,
                                              toListenableObject: self.listenableObject).first!
        self.listenableObject.remove(listener: listener)
        
        // attempt to remove again
        let removeResult = self.listenableObject.remove(listener: listener)
        
        XCTAssert(removeResult == false, "Non existent listener was attempted to be removed")
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
    
    // MARK: Enumerate listeners
    
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
