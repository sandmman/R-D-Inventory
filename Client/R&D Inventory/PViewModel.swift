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

    public let reloadCollectionViewCallback : (()->()) = () -> ()
    
    public let kNumberOfSectionsInTableView = 1
    
    public var selectedCell: T? = nil

    public var project: Project? = nil {
        didSet {
            startSync()
            stopSync()
            reloadCollectionViewCallback()
        }
    }

    public func startSync() {
        upcomingBuildsDataSource.startSync()
    }
    
    public func stopSync() {
        upcomingBuildsDataSource.stopSync()
    }
}

extension PViewModel {
    
    public func numberOfItemsInSection(section : Int) -> Int {
        
        return objectDataSource.count
        
    }
    
    public func numberOfSectionsInCollectionView() -> Int {
        
        return kNumberOfSectionsInTableView
        
    }
    
    public func selectedCell(at indexPath: IndexPath) {
        selectedCell = objectDataSource.list[indexPath.row]
    }
}

extension ViewModel: FirebaseDataSourceDelegate {
    
    internal func indexAdded<T : FIRDataObject>(at IndexPath: IndexPath, data: T) {
        reloadCollectionViewCallback()
    }
    
    internal func indexChanged<T : FIRDataObject>(at IndexPath: IndexPath, data: T) {
        reloadCollectionViewCallback()
    }
    
    internal func indexRemoved(at IndexPath: IndexPath, key: String) {
        reloadCollectionViewCallback()
    }
}
