//
//  CalendarDataSource.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/14/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

protocol FirebaseDictDataSourceDelegate {
    func indexAdded(data: Build)
    func indexChanged(data: Build)
    func indexRemoved(key: String)
}


class CalendarDataSource: NSObject {
    
    // MARK: Properties
    
    public var syncArray: FirebaseDictionary
    
    public var delegate: FirebaseDictDataSourceDelegate?
    
    // MARK: Computed properties
    
    public var count: Int {
        return 0//syncArray.list.count
    }
    
    public var dict: [String: [Build]] {
        return syncArray.dict
    }
    
    // MARK: Initializers
    
    public init(project: Project) {
        
        syncArray = FirebaseDictionary(project: project)
        
        super.init()
        
        syncArray.delegate = self
    }
    
    // MARK: Data Updates
    
    public func append(data: AnyObject!) {
        syncArray.append(data: data)
    }
    
    public func update(at index: Int, data: [NSObject: AnyObject?]) {
        syncArray.update(at: index, data: data)
    }
    
    public  func remove(build: Build) {
        _ = syncArray.remove(item: build)
    }
    
    // MARK: Syncing
    
    public func startSync() {
        syncArray.sync()
    }
    
    public func stopSync() {
        syncArray.dispose()
    }

}

extension CalendarDataSource: FirebaseDictionaryDelegate {

    func indexAdded(dict: [String: [Build]], data: Build) {
        delegate?.indexAdded(data: data)
    }

    func indexChanged(dict: [String: [Build]], data: Build) {
        delegate?.indexChanged(data: data)
    }

    func indexRemoved(dict: [String: [Build]], with key: String) {
        delegate?.indexRemoved(key: key)
    }
}
