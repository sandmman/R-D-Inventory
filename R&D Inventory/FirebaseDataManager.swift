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
    static let rootRef = FIRDatabase.database().reference()
    static let userRef = FIRDatabase.database().reference().child("users")
    static let partsRef = FIRDatabase.database().reference().child("parts")
    static let buildsRef = FIRDatabase.database().reference().child("builds")
    static let projectsRef = FIRDatabase.database().reference().child("projects")
    static let assemblyRef = FIRDatabase.database().reference().child("assemblies")

    fileprivate static var currentUserRef: FIRDatabaseReference? {
        guard let userID = UserDefaults.standard.string(forKey: "user") else {
            return nil
        }
        
        let currentUser = userRef.child(userID)
            
        return currentUser
    }
}

extension FirebaseDataManager {
    public static func removeListener(handle: UInt, ref: FIRDatabaseReference) {
        ref.removeObserver(withHandle: handle)
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
        
        assemblyRef.child(build.assemblyID).child("builds").updateChildValues([build.key: true])
        
        //projectsRef.child(build.projectID).child("builds").updateChildValues([build.key: true])
        
        buildsRef.child(build.key).setValue(build.toAnyObject())
    }
    
    public static func add(build: Build, to project: String) {
        
        assemblyRef.child(build.assemblyID).child("builds").updateChildValues([build.key: true])
        
        projectsRef.child(project).child("builds").updateChildValues([build.key: true])
        
        buildsRef.child(build.key).setValue(build.toAnyObject())
    }


    public static func add(part: Part) {
        partsRef.child(part.key).setValue(part.toAnyObject())
    }
    
    public static func add(project: Project) {
        projectsRef.child(project.key).setValue(project.toAnyObject())
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
        
        FirebaseDataManager.assemblyRef.child(build.assemblyID).child("builds").child(build.key).removeValue()
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
    
    public static func getParts(for assembly: Assembly, onComplete: @escaping (Part) -> ()) {
        
        for (ID, _) in assembly.parts {
            
            get(part: ID) { part in

                onComplete(part)
            }
        }
    }
    
    public static func getBuilds(for assembly: Assembly, onComplete: @escaping (Build) -> ()) {
        
        assemblyRef.child(assembly.key).child("builds").observeSingleEvent(of: .value, with: { snapshot in
            
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

    public static func getAssemblies(for project: Project, onComplete: @escaping (Assembly) -> ()) {
        for id in project.assemblies {
            self.get(assembly: id) { assembly in
                onComplete(assembly)
            }
        }
    }
    
    public static func get(build ID: String, onComplete: @escaping (Build) -> ()) {
        self.get(ref: buildsRef.child(ID), onComplete: onComplete)
    }
    
    public static func get(part ID: String, onComplete: @escaping (Part) -> ()) {
        self.get(ref: partsRef.child(ID), onComplete: onComplete)
    }
    
    public static func get(assembly ID: String, onComplete: @escaping (Assembly) -> ()) {
        self.get(ref: assemblyRef.child(ID), onComplete: onComplete)
    }

    public static func get(project ID: String, onComplete: @escaping (Project) -> ()) {
        self.get(ref: projectsRef.child(ID), onComplete: onComplete)
    }
}

extension FirebaseDataManager {
    internal static func get<T: FIRDataObject>(ref: FIRDatabaseReference, onComplete: @escaping (T) -> ()) {
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if let item = T(snapshot: snapshot) {
                onComplete(item)
            }
            
        }) {
            error in
            print(error.localizedDescription)
        }
    }
}
