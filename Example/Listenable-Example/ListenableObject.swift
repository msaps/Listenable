//
//  ListenableObject.swift
//  Listenable-Example
//
//  Created by Merrick Sapsford on 10/01/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import Foundation
import Listenable

protocol ListenableObjectDelegate {
    
    func listenableObjectDidProvideUpdate(_ listenableObject: ListenableObject)
}

class ListenableObject: Listenable<ListenableObjectDelegate> {
    
    
    /// Calls listenableObjectDidProvideUpdate on all registered listeners.
    func updateAllListeners() {
        self.updateListeners{ (listener, index) in
            listener.listenableObjectDidProvideUpdate(self)
        }
    }
}
