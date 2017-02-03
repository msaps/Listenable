//
//  ListenerViewController.swift
//  Listenable-Example
//
//  Created by Merrick Sapsford on 10/01/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import UIKit

class ListenerViewController: UIViewController, ListenableObjectDelegate {

    // MARK: Properties
    
    let listenableObject = ListenableObject()
    
    @IBOutlet weak var actionButton: ListenerButton!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listenableObject.add(listeners: [self, self.actionButton], priority: .high)
    }
    
    // MARK: Actions
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        self.listenableObject.updateAllListeners()
    }
    
    // MARK: ListenableObjectDelegate
    
    func listenableObjectDidProvideUpdate(_ listenableObject: ListenableObject) {
        print("ListenerViewController - listener update received")
    }
}

