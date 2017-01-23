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
    
    public var syncDict: FirebaseDictionary
    
    public var delegate: FirebaseDictDataSourceDelegate?
    
    public var dict: [String: [Build]] {
        return syncDict.dict
    }
    
    // MARK: Initializers
    
    public init(project: Project) {
        
        syncDict = FirebaseDictionary(project: project)
        
        super.init()
        
        syncDict.delegate = self
    }
    
    // MARK: Data Updates
    
    public func append(data: AnyObject!) {
        syncDict.append(data: data)
    }
    
    public func count(date: String) -> Int {
        return dict[date]?.count ?? 0
    }

    public func update(at index: Int, data: [NSObject: AnyObject?]) {
        syncDict.update(at: index, data: data)
    }
    
    public  func remove(at index: Int, for date: Date) -> Build? {
        return syncDict.remove(at: index, for: date)
    }

    public func startSync() {
        syncDict.sync()
    }
    
    public func stopSync() {
        syncDict.dispose()
    }
    
    public func updateProject(project: Project) {
        syncDict.project = project
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
