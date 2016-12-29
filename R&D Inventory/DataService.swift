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

class DataService {
    
    static let sharedInstance = DataService()

    private let _rootRef = FIRDatabase.database().reference()
    private let _userRef = FIRDatabase.database().reference().child("users")
    private let _assemblyRef = FIRDatabase.database().reference().child("assemblies")
    
    var rootRef: FIRDatabaseReference {
        return _rootRef
    }
        
    var userRef: FIRDatabaseReference {
        return _userRef
    }
        
    var currentUserRef: FIRDatabaseReference? {
        guard let userID = UserDefaults.standard.string(forKey: "user") else {
            return nil
        }
        
        let currentUser = _userRef.child(userID)
            
        return currentUser
    }
        
    var assemblyRef: FIRDatabaseReference {
        return _assemblyRef
    }
    
    var subscribedReplyHandle: UInt?
    
    var delegate: AssemblyDelegate!
    var allAssemblies: [[Assembly]] = []

    init() {
        assemblyRef.queryOrdered(byChild: "name").observe(.value, with: { snapshot in
            print("what")
            print(snapshot.value)
        })
    }
}

extension DataService: DataManager {
    
    func addAssembly(assembly: Assembly) {
        assemblyRef.setValue(assembly.toAnyObject())
    }
    
    func deleteAssembly(assembly: Assembly) {
        
    }
}
