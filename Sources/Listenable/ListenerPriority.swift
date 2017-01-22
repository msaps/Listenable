//
//  ListenerPriority.swift
//  Listenable
//
//  Created by Merrick Sapsford on 19/01/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import Foundation

/// Positional priority of a Listener within the enumeration queue. 
/// Ranges from 1 (low) to 1000 (high).
///
/// - low:    Listener is inserted at the end of the queue. (default)
/// - high:   Listener is inserted at the front of the queue.
/// - custom: Custom queue prioritisation value (Range: 1 - 999)
public enum ListenerPriority: Equatable {
    
    case low
    case high
    case custom(value: Int)
    
    internal var value: Int {
        get {
            switch self {
            case .high:
                return 1000
            case .custom(let value):
                return value
            default:
                return 0
            }
        }
    }
    
    public static func == (lhs: ListenerPriority, rhs: ListenerPriority) -> Bool {
        return lhs.value == rhs.value
    }
}
