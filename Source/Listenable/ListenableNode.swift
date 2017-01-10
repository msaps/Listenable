//
//  ListenableNode.swift
//  Pods
//
//  Created by Merrick Sapsford on 10/01/2017.
//
//

import Foundation

internal class ListenableNode<T> {
    
    weak var value: AnyObject?
    
    init(value: T) {
        self.value = value as AnyObject
    }
}
