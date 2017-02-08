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

    func indexAdded(dict: [String: [Build]], at indexPath: Int, data: Build)

    func indexChanged(dict: [String: [Build]], at indexPath: Int, data: Build)

    func indexRemoved(dict: [String: [Build]], at indexPath: Int, with key: String)

}

class FirebaseDictionary {
    
    private(set) var dict = [String: [Build]]()
    
    public var project: Project?
    
    public var delegate: FirebaseDictionaryDelegate? = nil
    
    private var listener = ListenerHandler()
    
    // MARK: Initializers
    
    public init(project: Project) {
        self.project = project
    }
    
    // MARK: Syncing
    
    public func sync() {
        initializeListeners()
    }
    
    public func dispose() {
        stopSyncing()
        dict.removeAll(keepingCapacity: false)
    }
    
    public func stopSyncing() {
        listener.removeListeners()
    }
    
    // MARK: Data updates
    
    public func append(data: Any!) {
        let pushIdref = Build.rootRef(with: nil).childByAutoId()
        pushIdref.setValue(data)
    }
    
    public func remove(at index: Int, for date: Date) -> Build? {
        guard var arr = dict[date.display] else {
            return nil
        }
        let obj = arr.remove(at: index)
        dict[date.display] = arr
        return obj
    }
    
    public func update(at index: Int, data: [NSObject : Any]!) {
    }
    
    // MARK: Event Listeners
    
    private func initializeListeners() {
        listener.listenForObjects(for: project, onComplete: didReceiveNotification)
    }
    
    private func didReceiveNotification(result: ObserverResult<Build>) {
        switch result {
        case .added(let obj)    : print("added"); serverAdd(item: obj)
        case .changed(let obj)  : print("changed"); serverChange(item: obj)
        case .removed(let key)  : print("removed"); serverRemove(key: key)
        }
    }
    
    private func serverAdd(item: Build) {
        if var arr = dict[item.displayDate] {
            arr.append(item)
            dict[item.displayDate] = arr
        } else {
            dict[item.displayDate] = [item]
        }
        delegate?.indexAdded(dict: dict, at: dict[item.displayDate]!.count - 1, data: item)
    }
    
    private func serverChange(item: Build) {
        guard let (k, position) = findKeyPosition(key: item.key) else {
            return
        }
        dict[k]?[position] = item
        delegate?.indexChanged(dict: dict, at: position,  data: item)
    }
    
    private func serverRemove(key: String) {
        guard let (k, position) = findKeyPosition(key: key), var arr = dict[k] else {
            return
        }
        
        arr.remove(at: position)
        dict[k] = arr

        delegate?.indexRemoved(dict: dict, at: position, with: key)
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
