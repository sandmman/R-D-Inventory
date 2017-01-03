//
//  Listener.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/2/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import Foundation

public struct ListenerHandler {
    var handles = [UInt]()
    
    /*public func listenForAssemblies(for project: Project, onComplete: @escaping (Assembly) -> ()) -> (UInt, UInt) {
        
        // let listener = Listener()
        // listener.listenForAssemblies
        let ref = projectsRef.child(project.key).child("assemblies")
        
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
    
    public func listenForParts(onComplete: @escaping (Part) -> ()) -> (UInt, UInt)  {
        return setupListenerPair(ref: partsRef, onComplete: onComplete)
    }
    
    public func listenForProjects(onComplete: @escaping (Project) -> ()) -> (UInt, UInt)  {
        return setupListenerPair(ref: projectsRef, onComplete: onComplete)
    }
    
    public func removeListener(handle: UInt) {
        partsRef.removeObserver(withHandle: handle)
    }

    public func removeListeners() {
        for handle in handles {
            FirebaseDataManager.removeListener(handle: handle)
        }
    }*/
}
