//
//  PViewModel.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/14/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class PViewModel<T: FIRDataObject>: NSObject {
    
    public var objectDataSource: FirebaseDataSource<T>!

    public var reloadCollectionViewCallback : (()->())!
    
    public var kNumberOfSectionsInTableView = 1
    
    public var selectedCell: T? = nil
    
    public var delegate: FirebaseTableViewDelegate? = nil

    public var project: Project? = nil {
        didSet {
            stopSync()
            startSync()
            reloadCollectionViewCallback()
        }
    }
    
    public init(objectDataSource: FirebaseDataSource<T>, callback: @escaping (()->()), project: Project? = nil) {
        self.objectDataSource = objectDataSource

        self.project = project

        self.reloadCollectionViewCallback = callback
    }

    public func startSync() {
        objectDataSource.startSync()
    }
    
    public func stopSync() {
        objectDataSource.stopSync()
    }
    
    public func numberOfItemsInSection(section : Int) -> Int {
        
        return objectDataSource.count
        
    }
    
    public func numberOfSectionsInCollectionView() -> Int {
        
        return kNumberOfSectionsInTableView
        
    }
    
    public func didSelectCell(at indexPath: IndexPath) {
        selectedCell = objectDataSource.list[indexPath.row]
    }
    
    public func delete(from tableView: UITableView, at indexPath: IndexPath) {
        objectDataSource.remove(at: indexPath.row)
    }

}

extension PViewModel: FirebaseDataSourceDelegate {
    
    internal func indexAdded<T : FIRDataObject>(at indexPath: IndexPath, data: T) {
        delegate?.indexAdded(at: indexPath, data: data)
    }
    
    internal func indexChanged<T : FIRDataObject>(at indexPath: IndexPath, data: T) {
        delegate?.indexChange(at: indexPath, data: data)
    }
    
    internal func indexRemoved(at indexPath: IndexPath, key: String) {
        delegate?.indexRemoved(at: indexPath, key: key)
    }
}
