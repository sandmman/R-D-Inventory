//
//  FirebaseDictionary.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/14/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit
import Firebase

protocol FirebaseDictionaryDelegate {
    func indexAdded(dict: [String: [Build]], data: Build)
    func indexChanged(dict: [String: [Build]], data: Build)
    func indexRemoved(dict: [String: [Build]], with key: String)
}

class FirebaseDictionary {
    
    var dict = [String: [Build]]()
    
    let project: Project?
    
    var delegate: FirebaseDictionaryDelegate? = nil
    
    var listener = ListenerHandler()
    
    // MARK: Initializers
    
    init(project: Project) {
        self.project = project
    }
    
    // MARK: Syncing
    
    func sync() {
        initializeListeners()
    }
    
    func dispose() {
        stopSyncing()
        dict.removeAll(keepingCapacity: false)
    }
    
    func stopSyncing() {
        listener.removeListeners()
    }
    
    // MARK: Data updates
    
    func append(data: Any!) {
        let pushIdref = Build.rootRef(with: nil).childByAutoId()
        pushIdref.setValue(data)
    }
    
    func remove(item: Build) -> Build? {
        guard var arr = dict[item.displayDate] else {
            return nil
        }
        let obj = arr.filter { $0 != item}
        dict[item.displayDate] = obj
        return nil
    }
    
    func update(at index: Int, data: [NSObject : Any]!) {
        //let item = list[index]
        //let itemRef = ref.child(item.key)
        //itemRef.updateChildValues(data)
    }
    
    // MARK: Event Listeners
    
    private func initializeListeners() {
        listener.listenForObjects(for: project, onComplete: didReceiveNotification)
    }
    
    private func didReceiveNotification(result: ObserverResult<Build>) {
        switch result {
        case .added(let obj)    : serverAdd(item: obj)
        case .changed(let obj)  : serverChange(item: obj)
        case .removed(let key)  : serverRemove(key: key)
        }
    }
    
    private func serverAdd(item: Build) {
        if var arr = dict[item.displayDate] {
            arr.append(item)
            dict[item.displayDate] = arr
        } else {
            dict[item.displayDate] = [item]
        }
        delegate?.indexAdded(dict: dict, data: item)
    }
    
    private func serverChange(item: Build) {
        guard let (k, position) = findKeyPosition(key: item.key) else {
            return
        }
        dict[k]?[position] = item
        delegate?.indexChanged(dict: dict, data: item)
    }
    
    private func serverRemove(key: String) {
        guard let (k, position) = findKeyPosition(key: key), var arr = dict[k] else {
            return
        }
        
        arr.remove(at: position)
        dict[k] = arr

        delegate?.indexRemoved(dict: dict, with: key)
    }
    
    private func findKeyPosition(key: String) -> (String, Int)? {
        for (k,v) in dict {
            for i in 0..<v.count {
                if v[i].key == key {
                    return (k,i)
                }
            }
        }
        return nil
    }
}
