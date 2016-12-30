//
//  AssemblyDataManager.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/29/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import Foundation
import Firebase

public protocol AssemblyDelegate {
    func onItemsAddedToList()
}

public protocol DataManager {
    func addAssembly(assembly: Assembly)
    func addPart(part: Part)
    func getParts(for assembly: Assembly, onAddPart: @escaping (Part) -> ())
    func updateAssembly(assembly: Assembly)
    func updatePart(part: Part)
    func deleteAssembly(assembly: Assembly)
}

public class DataService {
    
    public static let sharedInstance = DataService()

    private let _rootRef = FIRDatabase.database().reference()
    private let _userRef = FIRDatabase.database().reference().child("users")
    private let _assemblyRef = FIRDatabase.database().reference().child("assemblies")
    private let _partsRef = FIRDatabase.database().reference().child("parts")
    
    public var rootRef: FIRDatabaseReference {
        return _rootRef
    }
        
    public var userRef: FIRDatabaseReference {
        return _userRef
    }
        
    public var currentUserRef: FIRDatabaseReference? {
        guard let userID = UserDefaults.standard.string(forKey: "user") else {
            return nil
        }
        
        let currentUser = _userRef.child(userID)
            
        return currentUser
    }
        
    public var assemblyRef: FIRDatabaseReference {
        return _assemblyRef
    }
    
    public var partsRef: FIRDatabaseReference {
        return _partsRef
    }

    public var delegate: AssemblyDelegate!
    public var allAssemblies: [Assembly] = []
    
    public init() {
        assemblyRef.observe(.value, with: { snapshot in
            var newItems: [Assembly] = []

            for item in snapshot.children {
                let assemblyItem = Assembly(snapshot: item as! FIRDataSnapshot)
                newItems.append(assemblyItem)
            }
            
            self.allAssemblies = newItems
            self.delegate.onItemsAddedToList()
        })
    }
}

extension DataService: DataManager {
    
    public func addAssembly(assembly: Assembly) {
        assemblyRef.childByAutoId().setValue(assembly.toAnyObject())
    }
    
    public func addPart(part: Part) {
        partsRef.child(part.databaseID).setValue(part.toAnyObject())
    }

    public func getParts(for assembly: Assembly, onAddPart: @escaping (Part) -> ()) {

        for pointer in assembly.parts {
            partsRef.child(pointer).observeSingleEvent(of: .value, with: { snapshot in
                onAddPart(Part(snapshot: snapshot))
                
            }) {
                error in
                print(error.localizedDescription)
            }
        }
    }
    public func updateAssembly(assembly: Assembly) {
        
    }

    public func updatePart(part: Part) {
        
    }

    public func deleteAssembly(assembly: Assembly) {
        guard let ref = assembly.ref else {
            return
        }
        
        allAssemblies = allAssemblies.filter { $0 != assembly}

        ref.removeValue()
    }
    
    public func deletePart(part: Part) {
        guard let ref = part.ref else {
            return
        }

        ref.removeValue()
    }
}
