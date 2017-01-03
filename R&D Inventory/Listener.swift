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
    
    var handles = [UInt]()
    
}

extension ListenerHandler {
    
    public func listenForAssemblies(for project: Project, onComplete: @escaping (Assembly) -> ()) {

        let ref = FirebaseDataManager.projectsRef.child(project.key).child("assemblies")

        let h1 = ref.observe(.childAdded, with: { snapshot in
            
            let h2 = FirebaseDataManager.assemblyRef.child(snapshot.key).observe(.value, with: { snap in
                if let assembly = Assembly(snapshot: snap) {
                    onComplete(assembly)
                }
            })
            
            self.handles.append(h2)
        })
        
        self.handles.append(h1)
    }
    
    public func listenForParts(onComplete: @escaping (Part) -> ())  {
        setupListenerPair(ref: FirebaseDataManager.partsRef, onComplete: onComplete)
    }
    
    public func listenForProjects(onComplete: @escaping (Project) -> ())  {
        setupListenerPair(ref: FirebaseDataManager.projectsRef, onComplete: onComplete)
    }

    public func removeListeners() {
        for handle in handles {
            FirebaseDataManager.removeListener(handle: handle)
        }
        handles = []
    }
}

extension ListenerHandler {

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
        
        handles.append(h1)
        handles.append(h2)
    }
}
