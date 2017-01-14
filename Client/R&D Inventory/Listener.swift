//
//  Listener.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/2/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import Foundation
import Firebase

public enum ObserverResult<T: FIRDataObject> {
    case added(T)
    case removed(FIRDatabaseReference)
    case changed(T)
}

public class ListenerHandler {

    fileprivate var handles = [FIRDatabaseReference: [UInt]]()

}

extension ListenerHandler {
    
    public func listenForObjects<T: FIRDataObject>(for project: Project?, onComplete: @escaping (ObserverResult<T>) -> ()) {
        
        guard let project = project else {
            setupListenerTrio(ref: FirebaseDataManager.projectsRef, onComplete: onComplete)
            return
        }

        let parentRef = T.rootRef(with: project)
        let itemRef = T.rootRef(with: nil)

        setupListenerSet(parentRef: parentRef, itemRef: itemRef, onComplete: onComplete)
    }
    
    public func listenForObjects<T: FIRDataObject>(for assembly: Assembly, onComplete: @escaping (ObserverResult<T>) -> ()) {
        
        var parentRef: FIRDatabaseReference? = nil
        let itemRef = T.rootRef(with: nil)

        switch itemRef {
        case Part.rootRef() : parentRef = assembly.ref?.child(Constants.Types.Part)
        case Build.rootRef(): parentRef = assembly.ref?.child(Constants.Types.Build)
        default: break
        }
        
        guard let ref = parentRef else {
            return
        }

        setupListenerSet(parentRef: ref, itemRef: itemRef, onComplete: onComplete)
    }

    public func removeListeners() {
        for (ref, _) in handles {
            ref.removeAllObservers()
        }
        handles = [:]
    }
    
    public func removeListeners(to ref: FIRDatabaseReference) {
        guard let arr = handles[ref] else {
            return
        }
        for handle in arr {
            FirebaseDataManager.removeListener(handle: handle, ref: ref)
        }
        handles[ref] = []
    }
}

extension ListenerHandler {
    
    internal func setupListenerSet<T: FIRDataObject>(parentRef: FIRDatabaseReference, itemRef:  FIRDatabaseReference, onComplete: @escaping (ObserverResult<T>) -> ()) {
        
        let h1 = parentRef.observe(.childAdded, with: { snapshot in

            let h2 = itemRef.child(snapshot.key).observe(.value, with: { snap in

                if let item = T(snapshot: snap) {
                    onComplete(.changed(item))
                }
            })
            
            self.addRef(ref: itemRef.child(snapshot.key), handle: h2)
        })
        
        let h3 = parentRef.observe(.childRemoved, with: { snapshot in
            onComplete(.removed(itemRef.child(snapshot.key)))
        })
        
        addRef(ref: parentRef, handle: h1)
        addRef(ref: parentRef, handle: h3)

    }

    internal func setupListenerTrio<T: FIRDataObject>(ref: FIRDatabaseReference, onComplete: @escaping (ObserverResult<T>) -> ()) {

        let h1 = ref.observe(.childAdded, with: { snapshot in
            if let item = T(snapshot: snapshot) {
                onComplete(.added(item))
            }
        })
        
        let h2 = ref.observe(.childChanged, with: { snapshot in
            if let item = T(snapshot: snapshot) {
                onComplete(.changed(item))
            }
        })
        
        let h3 = ref.observe(.childRemoved, with: { snapshot in
            onComplete(.removed(ref.child(snapshot.key)))
        })

        addRef(ref: ref, handle: h1)
        addRef(ref: ref, handle: h2)
        addRef(ref: ref, handle: h3)

    }
    private func addRef(ref: FIRDatabaseReference, handle: UInt) {
        guard var arr = handles[ref] else {
            handles[ref] = [handle]
            return
        }

        arr.append(handle)

        handles[ref] = arr
    }
}
