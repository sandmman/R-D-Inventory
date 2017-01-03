//
//  AssemblyDataManager.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/29/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import Foundation
import Firebase

public struct FirebaseDataManager {
    
    // Firebase End Points
    fileprivate static let rootRef = FIRDatabase.database().reference()
    fileprivate static let userRef = FIRDatabase.database().reference().child("users")
    fileprivate static let partsRef = FIRDatabase.database().reference().child("parts")
    fileprivate static let buildsRef = FIRDatabase.database().reference().child("builds")
    fileprivate static let projectsRef = FIRDatabase.database().reference().child("projects")
    fileprivate static let assemblyRef = FIRDatabase.database().reference().child("assemblies")

    fileprivate static var currentUserRef: FIRDatabaseReference? {
        guard let userID = UserDefaults.standard.string(forKey: "user") else {
            return nil
        }
        
        let currentUser = userRef.child(userID)
            
        return currentUser
    }
}

extension FirebaseDataManager {
    
    public static func listenForAssemblies(for project: Project, onComplete: @escaping (Assembly) -> ()) -> (UInt, UInt) {
        
        // let listener = Listener()
        // listener.listenForAssemblies
        let ref = projectsRef.child(project.databaseID).child("assemblies")
        
        var handles = [UInt]()

        let h1 = ref.observe(.childAdded, with: { snapshot in
            
            let h2 = assemblyRef.child(snapshot.key).observe(.value, with: { snap in
                if let assembly = Assembly(snapshot: snap) {
                    onComplete(assembly)
                }
            })
            
            handles.append(h2)
        })
        
        handles.append(h1)
        
        return (h1, h1)
    }
    
    public static func listenForParts(onComplete: @escaping (Part) -> ()) -> (UInt, UInt)  {
        return setupListenerPair(ref: partsRef, onComplete: onComplete)
    }
    
    public static func listenForProjects(onComplete: @escaping (Project) -> ()) -> (UInt, UInt)  {
        return setupListenerPair(ref: projectsRef, onComplete: onComplete)
    }

    public static func removeListener(handle: UInt) {
        partsRef.removeObserver(withHandle: handle)
    }
}

extension FirebaseDataManager: DataManager {
    
    /*public func add(object: FIRDataObject) {
     
     var ref: FIRDatabaseReference? = nil
     
     switch (object) {
     case is Assembly: ref = assemblyRef
     case is Build: ref = buildsRef
     case is Part: ref = partsRef
     case is Project: ref = projectsRef
     default: break
     }
     
     
     }*/
    
    //////////
    // ADD //
    /////////

    public static func add(assembly: Assembly) {
        assemblyRef.childByAutoId().setValue(assembly.toAnyObject())
    }
    
    public static func add(build: Build) {
        
        assemblyRef.child(build.assemblyID).child("builds").updateChildValues([build.databaseID: true])
        
        buildsRef.child(build.databaseID).setValue(build.toAnyObject())
    }

    public static func add(part: Part) {
        partsRef.child(part.databaseID).setValue(part.toAnyObject())
    }
    
    public static func add(project: Project) {
        projectsRef.child(project.databaseID).setValue(project.toAnyObject())
    }

    ////////////
    // Update //
    ////////////

    public static func update(assembly: Assembly) {
        
    }
    
    public static func update(build: Build) {
        
    }

    public static func update(part: Part) {
        
    }
    
    public static func update(project: Project) {
        
    }

    ////////////
    // Delete //
    ////////////

    public static func delete(assembly: Assembly) {
        
        guard let ref = assembly.ref else {
            return
        }

        ref.removeValue()
    }
    
    public static func delete(part: Part) {
        
        guard let ref = part.ref else {
            return
        }

        ref.removeValue()
    }
    
    public static func delete(build: Build) {
        
        guard let ref = build.ref else {
            return
        }
        
        ref.removeValue()
        
        FirebaseDataManager.assemblyRef.child(build.assemblyID).child("builds").child(build.databaseID).removeValue()
    }
    
    public static func delete(project: Project) {
        
        guard let ref = project.ref else {
            return
        }
        
        ref.removeValue()
    }
    
    //////////
    // GET //
    /////////
    
    public static func get(assembly: Assembly, onAddPart: @escaping (Part) -> ()) {
        
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
    
    public static func getParts(for assembly: Assembly, onComplete: @escaping (Part) -> ()) {
        
        for (ID, count) in assembly.parts {
            
            get(part: ID) { part in
                
                part.countInAssembly = count
                
                onComplete(part)
            }
        }
    }
    
    public static func getBuilds(for assembly: Assembly, onComplete: @escaping (Build) -> ()) {
        
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

    public static func get(assembly: String, onComplete: @escaping (Assembly) -> ()) {
        
        partsRef.child(assembly).observeSingleEvent(of: .value, with: { snapshot in
            
            if let assembly = Assembly(snapshot: snapshot) {
                onComplete(assembly)
            }
            
        }) {
            error in
            print(error.localizedDescription)
        }
    }
    
    public static func get(build: String, onComplete: @escaping (Build) -> ()) {
        
        self.buildsRef.child(build).observeSingleEvent(of: .value, with: { snapshot in

            if let build = Build(snapshot: snapshot) {
                onComplete(build)
            }
            
        }) {
            error in
            print(error.localizedDescription)
        }
    }
    
    public static func get(part: String, onComplete: @escaping (Part) -> ()) {
       
        self.partsRef.child(part).observeSingleEvent(of: .value, with: { snapshot in
            
            if let part = Part(snapshot: snapshot) {
                onComplete(part)
            }
            
        }) {
            error in
            print(error.localizedDescription)
        }
    }
    
    public static func get(project: String, onComplete: @escaping (Project) -> ()) {
        
        self.projectsRef.child(project).observeSingleEvent(of: .value, with: { snapshot in
            
            if let project = Project(snapshot: snapshot) {
                onComplete(project)
            }
            
        }) {
            error in
            print(error.localizedDescription)
        }
    }
}

extension FirebaseDataManager {
    
    internal static func setupListenerPair<T: FIRDataObject>(ref: FIRDatabaseReference, onComplete: @escaping (T) -> ()) -> (UInt, UInt)  {
        
        let h1 = ref.observe(.childAdded, with: { snapshot in
            if let project = T(snapshot: snapshot) {
                onComplete(project)
            }
        })
        
        let h2 = ref.observe(.childChanged, with: { snapshot in
            if let project = T(snapshot: snapshot) {
                onComplete(project)
            }
        })
        
        return (h1, h2)
    }
}
