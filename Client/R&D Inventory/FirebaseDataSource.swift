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
    func indexRemoved<T: FIRDataObject>(at IndexPath: IndexPath, data: T)
}

class FirebaseDataSource<T: FIRDataObject>: NSObject, FirebaseArrayDelegate {
    

    
    // MARK: Properties
    
    private var syncArray: FirebaseArray<T>

    var delegate: FirebaseDataSourceDelegate?
    
    // MARK: Computed properties
    
    var count: Int {
        return syncArray.list.count
    }
    
    var list: [T] {
        return syncArray.list
    }

    public var id: String

    // MARK: Initializers
    
    init(id: String, ref: FIRDatabaseReference) {
        self.id = id

        syncArray = FirebaseArray(ref: ref)

        super.init()

        syncArray.delegate = self
    }
    
    // MARK: Data Updates
    
    func append(data: AnyObject!) {
        syncArray.append(data: data)
    }
    
    func update(at index: Int, data: [NSObject: AnyObject?]) {
        syncArray.update(at: index, data: data)
    }
    
    func remove(at index: Int) {
        syncArray.remove(at: index)
    }
    
    // MARK: Syncing
    
    func startSync() {
        syncArray.sync()
    }
    
    func stopSync() {
        syncArray.dispose()
    }
    
    func firebaseArray(array: [FIRDataSnapshot], oldIndex: Int, newIndex: Int, data: FIRDataSnapshot) {
        //let oldPath = createIndexPath(row: oldIndex)
        //let newPath = createIndexPath(row: newIndex)
        //delegate?.indexMoved(firebaseDataSource: self, at: oldPath, toIndexPath: newPath, data: data)
    }
    
    // MARK: IndexPath Helpers
    
    func createIndexPath(row: Int, section: Int = 0) -> IndexPath {
        return IndexPath(row: row, section: section)
    }
    
    internal func indexAdded<T : FIRDataObject>(array: [T], at indexPath: Int, data: T) {
        let path = createIndexPath(row: indexPath)
        delegate?.indexAdded(at: path, data: data)
    }

    internal func indexChanged<T : FIRDataObject>(array: [T], at indexPath: Int, data: T) {
        let path = createIndexPath(row: indexPath)
        delegate?.indexChanged(at: path, data: data)
    }
    
    internal func indexRemoved<T : FIRDataObject>(array: [T], at indexPath: Int, data: T) {
        let path = createIndexPath(row: indexPath)
        delegate?.indexRemoved(at: path, data: data)
    }

}

