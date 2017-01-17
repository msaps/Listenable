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
    
    init(value: T) {
        self.value = value as AnyObject
    }
}
