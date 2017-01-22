//
//  ListenerNode.swift
//  Listenable
//
//  Created by Merrick Sapsford on 10/01/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import Foundation

internal class ListenerNode<T> {
    
    weak var value: AnyObject?
    var priority: Int
    
    init(value: T, priority: Int) {
        self.value = value as AnyObject
        self.priority = priority
    }
}
