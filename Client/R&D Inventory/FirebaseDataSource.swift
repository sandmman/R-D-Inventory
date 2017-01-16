//
//  FirebaseDataSource.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/14/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit
import Firebase

protocol FirebaseDataSourceDelegate {
    func indexAdded<T: FIRDataObject>(at IndexPath: IndexPath, data: T)
    func indexChanged<T: FIRDataObject>(at IndexPath: IndexPath, data: T)
    func indexRemoved(at IndexPath: IndexPath, key: String)
}

class FirebaseDataSource<T: FIRDataObject>: NSObject {
    
    // MARK: Properties
    
    public var syncArray: FirebaseArray<T>

    public var delegate: FirebaseDataSourceDelegate?
    
    // MARK: Computed properties
    
    public var count: Int {
        return syncArray.list.count
    }
    
    public var list: [T] {
        return syncArray.list
    }

    public var section: Int

    // MARK: Initializers
    
    public init(section: Int, project: Project, assembly: Assembly? = nil) {
        self.section = section

        syncArray = FirebaseArray(project: project, assembly: assembly)

        super.init()

        syncArray.delegate = self
    }
    
    public init(section: Int) {
        self.section = section
        
        syncArray = FirebaseArray(project: nil)
        
        super.init()
        
        syncArray.delegate = self
    }
    
    // MARK: Data Updates
    
    public func append(data: AnyObject!) {
        syncArray.append(data: data)
    }
    
    public func update(at index: Int, data: T) {
        syncArray.update(at: index, data: data)
    }
    
   public  func remove(at index: Int) {
        syncArray.remove(at: index)
    }
    
    // MARK: Syncing
    
    public func startSync() {
        syncArray.sync()
    }
    
    public func stopSync() {
        syncArray.dispose()
    }
    
    // MARK: IndexPath Helpers
    
    public func createIndexPath(row: Int) -> IndexPath {
        return IndexPath(row: row, section: self.section)
    }

}

extension FirebaseDataSource: FirebaseArrayDelegate {

    internal func indexAdded<T : FIRDataObject>(array: [T], at indexPath: Int, data: T) {
        let path = createIndexPath(row: indexPath)
        delegate?.indexAdded(at: path, data: data)
    }
    
    internal func indexChanged<T : FIRDataObject>(array: [T], at indexPath: Int, data: T) {
        let path = createIndexPath(row: indexPath)
        delegate?.indexChanged(at: path, data: data)
    }
    
    internal func indexRemoved<T : FIRDataObject>(array: [T], at indexPath: Int, with key: String) {
        let path = createIndexPath(row: indexPath)
        delegate?.indexRemoved(at: path, key: key)
    }
}

