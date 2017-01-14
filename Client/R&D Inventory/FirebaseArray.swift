//
//  FirebaseArray.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/14/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit
import Firebase

protocol FirebaseArrayDelegate {
    func indexAdded<T: FIRDataObject>(array: [T], at indexPath: Int, data: T)
    func indexChanged<T: FIRDataObject>(array: [T], at indexPath: Int, data: T)
    func indexRemoved<T: FIRDataObject>(array: [T], at indexPath: Int, data: T)
}

class FirebaseArray<T: FIRDataObject> {
    
    var list = [T]()

    let ref: FIRDatabaseReference!

    var delegate: FirebaseArrayDelegate? = nil

    // MARK: Initializers
    
    init(ref: FIRDatabaseReference) {
        self.ref = ref
    }
    
    // MARK: Syncing
    
    func sync() {
        initializeListeners()
    }
    
    func dispose() {
        stopSyncing()
        list.removeAll(keepingCapacity: false)
    }
    
    func stopSyncing() {
        ref.removeAllObservers()
    }
    
    // MARK: Data updates
    
    func append(data: Any!) {
        let pushIdref = ref.childByAutoId()
        pushIdref.setValue(data)
    }
    
    func remove(at index: Int) {
        let obj = list[index]
        let itemRef = ref.child(obj.key)
        itemRef.removeValue()
    }
    
    func update(at index: Int, data: [NSObject : Any]!) {
        let item = list[index]
        let itemRef = ref.child(item.key)
        itemRef.updateChildValues(data)
    }
    
    // MARK: Event Listeners
    
    private func initializeListeners() {
        addListenerWithPrevKey(event: .childAdded, method: serverAdd)
        addListenerWithPrevKey(event: .childMoved, method: serverMove)
        addListener(event: .childChanged, method: serverChange)
        addListener(event: .childRemoved, method: serverRemove)
    }
    
    private func addListener(event: FIRDataEventType, method: @escaping (FIRDataSnapshot!) -> Void) {
        ref.observe(event, with: method)
    }
    
    private func addListenerWithPrevKey(event: FIRDataEventType, method: @escaping (FIRDataSnapshot?, String?) -> Void) {
        ref.observe(event, andPreviousSiblingKeyWith: method)
    }
    
    private func serverAdd(snap: FIRDataSnapshot?, prevKey: String?) {
        guard let snap = snap, let item = T(snapshot: snap) else {
            return
        }
        let position = moveTo(key: snap.key, data: snap, prevKey: prevKey)
        delegate?.indexAdded(array: list, at: position, data: item)
    }
    
    private func serverChange(snap: FIRDataSnapshot!) {
        let position = findKeyPosition(key: snap.key)
        if let position = position {
            guard let item = T(snapshot: snap) else {
                return
            }
            list[position] = item
            delegate?.indexChanged(array: list, at: position, data: item)
        }
    }
    
    private func serverRemove(snap: FIRDataSnapshot!) {
        let position = findKeyPosition(key: snap.key)
        if let position = position {
            let item = list.remove(at: position)
            delegate?.indexRemoved(array: list, at: position, data: item)
        }
    }
    
    private func serverMove(snap: FIRDataSnapshot?, prevKey: String?) {

    }
    
    private func moveTo(key: String, data: FIRDataSnapshot, prevKey: String?) -> Int {
        let position = placeRecord(key: key, prevKey: prevKey)
        guard let item = T(snapshot: data) else {
            return -1
        }
        list.insert(item, at: position)
        return position
    }
    
    private func placeRecord(key: String, prevKey: String?) -> Int {
        
        if let prevKey = prevKey {
            let i = findKeyPosition(key: prevKey)
            if let i = i {
                return i + 1
            } else {
                return list.count
            }
        } else {
            return 0
        }
        
    }
    
    private func findKeyPosition(key: String) -> Int? {
        for i in 0 ..< list.count {
            let item = list[i]
            if item.key == key {
                return i
            }
        }
        return nil
    }
    
}
