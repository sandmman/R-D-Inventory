//
//  AssemblyDataManager.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/29/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import Foundation
import Firebase

protocol AssemblyDelegate {
    func onItemsAddedToList()
}

protocol DataManager {
    func addAssembly(assembly: Assembly)
    func deleteAssembly(assembly: Assembly)
}

class AssemblyDataManager {

    var delegate: AssemblyDelegate!
    var allAssemblies: [[Assembly]] = []
    
    static let sharedInstance = AssemblyDataManager()
    
}

extension AssemblyDataManager: DataManager {
    
    func addAssembly(assembly: Assembly) {
        
    }
    
    func deleteAssembly(assembly: Assembly) {
        
    }
}
