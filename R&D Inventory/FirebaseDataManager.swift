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
    static let userRef = FIRDatabase.database().reference().child(Constants.Types.User)
    static let partsRef = FIRDatabase.database().reference().child(Constants.Types.Part)
    static let buildsRef = FIRDatabase.database().reference().child(Constants.Types.Build)
    static let projectsRef = FIRDatabase.database().reference().child(Constants.Types.Project)
    static let assemblyRef = FIRDatabase.database().reference().child(Constants.Types.Assembly)

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
    
    public static func save(project: Project) {
        projectsRef.child(project.key).setValue(project.toAnyObject())
    }
    
    public static func save(assembly: Assembly, to project: Project) {
        guard let ref = project.ref else { return }
        rootRef.updateChildValues(["/projects/\(project.key)/assemblies/\(assembly.key)": true,
                                   "/assemblies/\(assembly.key)": assembly.toAnyObject()])
        add(item: assembly, to: ref)
    }
    
    public static func save(build: Build, to project: Project) {
        guard let ref = project.ref else { return }
        add(item: build, to: ref)
    }
    
    public static func save(part: Part, to project: Project) {
        guard let ref = project.ref else { return }
        add(item: part, to: ref)
    }
    
    public static func save(build: Build, to assembly: Assembly, within project: Project) {
        save(build: build, to: project)
        add(build: build, to: assembly)
    }
    
    public static func save(part: Part, to assembly: Assembly, within project: Project) {
        save(part: part, to: project)
        add(part: part, to: assembly)
    }
    
    public static func add(build: Build, to assembly: Assembly) {
        guard let ref = assembly.ref else { return }
        ref.child(Constants.Types.Build).updateChildValues([build.key: true])
    }
    
    public static func add(part: Part, to assembly: Assembly) {
        guard let ref = assembly.ref else { return }
        ref.child(Constants.Types.Part).updateChildValues([part.key: true])
        
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

    public static func update<T: FIRDataObject>(object: T) {
        object.ref?.updateChildValues(object.toAnyObject() as! [AnyHashable : Any])
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
        
        FirebaseDataManager.assemblyRef.child(build.assemblyID).child(Constants.Types.Build).child(build.key).removeValue()
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
    
    public static func getProjects(onComplete: @escaping ([Project]) -> ()) {
        projectsRef.observeSingleEvent(of: .value, with: { snapshot in
            
            var projects = [Project]()

            for child in snapshot.children {
                
                guard let proj = Project(snapshot: child as! FIRDataSnapshot) else {
                    continue
                }
                projects.append(proj)
            }

            onComplete(projects)
        })
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
    
    internal static func add<T: FIRDataObject> (item: T, to projectRef: FIRDatabaseReference) {
        switch item {
        case is Part:
            
            partsRef.child(item.key).setValue(item.toAnyObject())
            
            projectRef.child(Constants.Types.Part).updateChildValues([item.key: true])
            
        case is Build:
            
            buildsRef.child(item.key).setValue(item.toAnyObject())
            
            projectRef.child(Constants.Types.Build).updateChildValues([item.key: true])
            
        case is Assembly:
            
            assemblyRef.child(item.key).setValue(item.toAnyObject())
            
            projectRef.child(Constants.Types.Assembly).updateChildValues([item.key: true])
            
        default: break
        }
    }
}
