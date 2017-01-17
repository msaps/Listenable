//
//  ListenerButton.swift
//  Listenable-Example
//
//  Created by Merrick Sapsford on 10/01/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import UIKit

class ListenerButton: UIButton, ListenableObjectDelegate {

    // MARK: ListenableObjectDelegate
    
    func listenableObjectDidProvideUpdate(_ listenableObject: ListenableObject) {
        print("ListenerButton - listener update received")
    }
    
}
