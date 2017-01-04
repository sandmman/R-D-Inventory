//
//  Listener.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/2/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import Foundation
import Firebase

public class ListenerHandler {
    
    var handles = [UInt: FIRDatabaseReference]()
    
}

extension ListenerHandler {
    
    public func listenForAssemblies(for project: Project, onComplete: @escaping (Assembly) -> ()) {
        let parentRef = FirebaseDataManager.projectsRef.child(project.key).child("assemblies")
        setupListenerSet(parentRef: parentRef, itemRef: FirebaseDataManager.assemblyRef, onComplete: onComplete)
    }
    
    public func listenForBuilds(for project: Project, onComplete: @escaping (Build) -> ()) {
        let parentRef = FirebaseDataManager.projectsRef.child(project.key).child("builds")
        setupListenerSet(parentRef: parentRef, itemRef: FirebaseDataManager.buildsRef, onComplete: onComplete)
    }

    public func listenForParts(onComplete: @escaping (Part) -> ())  {
        setupListenerPair(ref: FirebaseDataManager.partsRef, onComplete: onComplete)
    }
    
    public func listenForProjects(onComplete: @escaping (Project) -> ())  {
        setupListenerPair(ref: FirebaseDataManager.projectsRef, onComplete: onComplete)
    }

    public func removeListeners() {
        for (handle, ref) in handles {
            FirebaseDataManager.removeListener(handle: handle, ref: ref)
        }
        handles = [:]
    }
}

extension ListenerHandler {
    
    internal func setupListenerSet<T: FIRDataObject>(parentRef: FIRDatabaseReference, itemRef:  FIRDatabaseReference, onComplete: @escaping (T) -> ()) {
        
        let h1 = parentRef.observe(.childAdded, with: { snapshot in

            let h2 = itemRef.child(snapshot.key).observe(.value, with: { snap in

                if let item = T(snapshot: snap) {
                    onComplete(item)
                }
            })
            
            self.handles[h2] = itemRef.child(snapshot.key)
        })
        
        self.handles[h1] = parentRef
    
    }

    internal func setupListenerPair<T: FIRDataObject>(ref: FIRDatabaseReference, onComplete: @escaping (T) -> ()) {
        
        let h1 = ref.observe(.childAdded, with: { snapshot in
            if let item = T(snapshot: snapshot) {
                onComplete(item)
            }
        })
        
        let h2 = ref.observe(.childChanged, with: { snapshot in
            if let item = T(snapshot: snapshot) {
                onComplete(item)
            }
        })
        
        handles[h1] = ref
        handles[h2] = ref
    }
}
