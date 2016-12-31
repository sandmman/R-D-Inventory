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

public class FirebaseDataManager: NSObject {
    
    //Make FirebaseDataManager a singlton
    public static let sharedInstance: FirebaseDataManager = {
        
        var manager = FirebaseDataManager()
        
        return manager
    }()
    
    
    public var assemblies = [Assembly]()

    public var delegate: AssemblyDelegate!
    

    // Firebase End Points
    fileprivate let rootRef = FIRDatabase.database().reference()
    fileprivate let userRef = FIRDatabase.database().reference().child("users")
    fileprivate let assemblyRef = FIRDatabase.database().reference().child("assemblies")
    fileprivate let partsRef = FIRDatabase.database().reference().child("parts")
    fileprivate let buildsRef = FIRDatabase.database().reference().child("builds")
        
    fileprivate var currentUserRef: FIRDatabaseReference? {
        guard let userID = UserDefaults.standard.string(forKey: "user") else {
            return nil
        }
        
        let currentUser = userRef.child(userID)
            
        return currentUser
    }

    
    
    fileprivate override init() {
        super.init()
        listenForAssemblies()
    }
}

extension FirebaseDataManager: DataManager {
    
    public func listenForAssemblies() {
        assemblyRef.observe(.value, with: { snapshot in
            var newItems: [Assembly] = []
            
            for item in snapshot.children {
                let assemblyItem = Assembly(snapshot: item as! FIRDataSnapshot)
                newItems.append(assemblyItem)
            }
            
            self.assemblies = newItems
            self.delegate.onItemsAddedToList()
        })
    }

    public func addAssembly(assembly: Assembly) {
        assemblyRef.childByAutoId().setValue(assembly.toAnyObject())
    }
    
    public func addPart(part: Part) {
        partsRef.child(part.databaseID).setValue(part.toAnyObject())
    }
    
    public func getAssemblies(for assembly: Assembly, onAddPart: @escaping (Part) -> ()) {
        
        for (ID, count) in assembly.parts {
            partsRef.child(ID).observeSingleEvent(of: .value, with: { snapshot in
                let part = Part(snapshot: snapshot)
                part.countInAssembly = count
                onAddPart(part)
                
            }) {
                error in
                print(error.localizedDescription)
            }
        }
    }

    public func getParts(for assembly: Assembly, onAddPart: @escaping (Part) -> ()) {

        for (ID, count) in assembly.parts {
            partsRef.child(ID).observeSingleEvent(of: .value, with: { snapshot in
                let part = Part(snapshot: snapshot)
                part.countInAssembly = count
                onAddPart(part)
                
            }) {
                error in
                print(error.localizedDescription)
            }
        }
    }
    
    public func getBuilds(for assembly: Assembly, onComplete: @escaping ([Build]) -> ()) {
        
            buildsRef.child(assembly.databaseID).observeSingleEvent(of: .value, with: { snapshot in
                //let builds = Build(snapshot: snapshot)
                onComplete([])
                
            })
    }

    public func updateAssembly(assembly: Assembly) {
        
    }

    public func updatePart(part: Part) {
        
    }

    public func deleteAssembly(assembly: Assembly) {
        guard let ref = assembly.ref else {
            return
        }
        
        assemblies = assemblies.filter { $0 != assembly}

        ref.removeValue()
    }
    
    public func deletePart(part: Part) {
        guard let ref = part.ref else {
            return
        }

        ref.removeValue()
    }
}
