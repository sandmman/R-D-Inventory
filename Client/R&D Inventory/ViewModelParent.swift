//
//  ViewModelParent.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/13/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class FormViewModelParent: NSObject {
    
    public let listener = ListenerHandler()
    
    public let reloadViewCallback : (()->())!

    public var project: Project? = nil {
        didSet {
            self.didChangeProject()
        }
    }
    
    public init(project: Project, reloadViewCallback : @escaping (()->())) {
        
        self.project = project
        
        self.reloadViewCallback = reloadViewCallback

        super.init()
        
        listenForObjects()
        
    }
    
    public init(reloadViewCallback : @escaping (()->())) {
        
        self.reloadViewCallback = reloadViewCallback

        super.init()
        
        listenForObjects()
        
    }
    
    public func didChangeProject() {
        reloadViewCallback()
    }

    public func listenForObjects() {
        
    }
    
    public func deinitialize() {
        listener.removeListeners()
    }
}
