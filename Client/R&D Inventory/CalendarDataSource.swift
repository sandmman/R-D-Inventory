//
//  CalendarDataSource.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/14/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

protocol FirebaseDictDataSourceDelegate {

    func indexAdded(at indexPath: IndexPath, data: Build)

    func indexChanged(at indexPath: IndexPath, data: Build)

    func indexRemoved(at indexPath: IndexPath, key: String)

}

class CalendarDataSource: NSObject {
    
    public var syncArray: FirebaseDictionary
    
    public var delegate: FirebaseDictDataSourceDelegate?
    
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
    
    public func count(date: String) -> Int {
        return dict[date]?.count ?? 0
    }

    public func update(at index: Int, data: [NSObject: AnyObject?]) {
        syncArray.update(at: index, data: data)
    }
    
    public  func remove(build: Build) {
        _ = syncArray.remove(item: build)
    }

    public func startSync() {
        syncArray.sync()
    }
    
    public func stopSync() {
        syncArray.dispose()
    }
    
    public func createIndexPath(row: Int, section: Int = 0) -> IndexPath {
        return IndexPath(row: row, section: section)
    }
}

extension CalendarDataSource: FirebaseDictionaryDelegate {

    func indexAdded(dict: [String: [Build]], at indexPath: Int,  data: Build) {
        delegate?.indexAdded(at: createIndexPath(row: indexPath), data: data)
    }

    func indexChanged(dict: [String: [Build]], at indexPath: Int,  data: Build) {
        delegate?.indexChanged(at: createIndexPath(row: indexPath), data: data)
    }

    func indexRemoved(dict: [String: [Build]], at indexPath: Int,  with key: String) {
        delegate?.indexRemoved(at: createIndexPath(row: indexPath), key: key)
    }
}
