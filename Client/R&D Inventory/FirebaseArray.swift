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
    func indexRemoved<T: FIRDataObject>(array: [T], at indexPath: Int, with key: String)
}

class FirebaseArray<T: FIRDataObject> {
    
    private(set) var list = [T]()

    var project: Project?
    
    let assembly: Assembly?

    var delegate: FirebaseArrayDelegate? = nil
    
    private(set) var listener = ListenerHandler()

    // MARK: Initializers
    
    init(project: Project?, assembly: Assembly? = nil) {
        self.project = project
        self.assembly = assembly
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
        listener.removeListeners()
    }
    
    // MARK: Data updates
    
    func append(data: Any!) {
        let pushIdref = T.rootRef(with: nil).childByAutoId()
        pushIdref.setValue(data)
    }
    
    func remove(at index: Int) -> T {
        return list.remove(at: index)
    }
    
    func update(at index: Int, data: T) {
        data.ref?.updateChildValues(data.toAnyObject() as! [AnyHashable : Any])
    }
    
    // MARK: Event Listeners
    
    private func initializeListeners() {
        if let assem = assembly {
            listener.listenForObjects(for: assem, onComplete: didReceiveNotification)
        } else {
            listener.listenForObjects(for: project, onComplete: didReceiveNotification)
        }
        
    }

    private func didReceiveNotification(result: ObserverResult<T>) {
        switch result {
        case .added(let obj)    : serverAdd(item: obj, prevKey: obj.key)
        case .changed(let obj)  : serverChange(item: obj)
        case .removed(let key)  : serverRemove(key: key)
        }
    }

    private func serverAdd(item: T, prevKey: String?) {
        let position = moveTo(key: item.key, data: item, prevKey: prevKey)
        delegate?.indexAdded(array: list, at: position, data: item)
    }
    
    private func serverChange(item: T) {
        guard let position = findKeyPosition(key: item.key) else {
            return
        }
        list[position] = item
        delegate?.indexChanged(array: list, at: position, data: item)
    }
    
    private func serverRemove(key: String) {
        guard let position = findKeyPosition(key: key) else {
            return
        }
        let _ = list.remove(at: position)
        delegate?.indexRemoved(array: list, at: position, with: key)
    }
    
    private func serverMove(snap: FIRDataSnapshot?, prevKey: String?) {

    }
    
    private func moveTo(key: String, data: T, prevKey: String?) -> Int {
        let position = placeRecord(key: key, prevKey: prevKey)
        
        list.insert(data, at: position)

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
