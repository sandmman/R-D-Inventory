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

public class FirebaseDataManager: NSObject {
    
    //Make FirebaseDataManager a singlton
    public static let sharedInstance: FirebaseDataManager = {
        
        var manager = FirebaseDataManager()
        
        return manager
    }()
    
    
    public var assemblies = [Assembly]()

    public var delegate: AssemblyDelegate? = nil
    
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

extension FirebaseDataManager {
    
    public func listenForAssemblies() {
        
        assemblyRef.observe(.value, with: { snapshot in
            var newItems: [Assembly] = []

            for item in snapshot.children {
                if let assemblyItem = Assembly(snapshot: item as! FIRDataSnapshot) {
                    newItems.append(assemblyItem)
                }
            }
            
            self.assemblies = newItems
            self.delegate?.onItemsAddedToList()
        })
    }
    
    public func listenForParts(onAddPart: @escaping (Part) -> ()) {
        
        partsRef.observe(.value, with: { snapshot in
            
            for item in snapshot.children {
                if let part = Part(snapshot: item as! FIRDataSnapshot) {
                    onAddPart(part)
                }
            }
        })
    }
}

extension FirebaseDataManager: DataManager {

    public func add(assembly: Assembly) {
        assemblyRef.childByAutoId().setValue(assembly.toAnyObject())
    }
    
    public func add(build: Build) {
        
        assemblyRef.child(build.assemblyID).child("builds").updateChildValues([build.databaseID: true])
        
        buildsRef.child(build.databaseID).setValue(build.toAnyObject())
    }

    public func add(part: Part) {
        partsRef.child(part.databaseID).setValue(part.toAnyObject())
    }
    
    public func get(assembly: Assembly, onAddPart: @escaping (Part) -> ()) {
        
        for (ID, count) in assembly.parts {
            partsRef.child(ID).observeSingleEvent(of: .value, with: { snapshot in
                if let part = Part(snapshot: snapshot) {
                    part.countInAssembly = count
                    onAddPart(part)
                }
                
            }) {
                error in
                print(error.localizedDescription)
            }
        }
    }

    public func getParts(for assembly: Assembly, onComplete: @escaping (Part) -> ()) {

        for (ID, count) in assembly.parts {
            
            get(part: ID) { part in
                
                part.countInAssembly = count

                onComplete(part)
            }
        }
    }
    
    public func getBuilds(for assembly: Assembly, onComplete: @escaping (Build) -> ()) {

        assemblyRef.child(assembly.databaseID).child("builds").observeSingleEvent(of: .value, with: { snapshot in

            guard let builds = snapshot.value as? [String: Bool] else {
                return
            }
            
            for (id, _) in builds {
                self.get(build: id) { build in
                    onComplete(build)
                }
            }
        
        }) {
            error in
            print(error.localizedDescription)
        }
    }

    public func update(assembly: Assembly) {
        
    }
    
    public func update(build: Build) {
        
    }

    public func update(part: Part) {
        
    }

    public func delete(assembly: Assembly) {
        
        guard let ref = assembly.ref else {
            return
        }
        
        assemblies = assemblies.filter { $0 != assembly}

        ref.removeValue()
    }
    
    public func delete(part: Part) {
        
        guard let ref = part.ref else {
            return
        }

        ref.removeValue()
    }
    
    public func delete(build: Build) {
        
        guard let ref = build.ref else {
            return
        }
        
        ref.removeValue()
        
        assemblyRef.child(build.assemblyID).child("builds").child(build.databaseID).removeValue()
    }

    public func get(assembly: String, onComplete: @escaping (Assembly) -> ()) {
        
        partsRef.child(assembly).observeSingleEvent(of: .value, with: { snapshot in
            
            if let assembly = Assembly(snapshot: snapshot) {
                onComplete(assembly)
            }
            
        }) {
            error in
            print(error.localizedDescription)
        }
    }
    
    public func get(build: String, onComplete: @escaping (Build) -> ()) {
        
        self.buildsRef.child(build).observeSingleEvent(of: .value, with: { snapshot in

            if let build = Build(snapshot: snapshot) {
                onComplete(build)
            }
            
        }) {
            error in
            print(error.localizedDescription)
        }
    }
    
    public func get(part: String, onComplete: @escaping (Part) -> ()) {
       
        self.partsRef.child(part).observeSingleEvent(of: .value, with: { snapshot in
            
            if let part = Part(snapshot: snapshot) {
                onComplete(part)
            }
            
        }) {
            error in
            print(error.localizedDescription)
        }
    }
}
