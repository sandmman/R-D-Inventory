//
//  PViewModel.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/14/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class PViewModel<T: FIRDataObject, S: FIRDataObject>: NSObject {
    
    private(set) var objectDataSources: (FirebaseDataSource<T>, FirebaseDataSource<S>?)
    
    private(set) var kNumberOfSectionsInTableView = 1
    
    public var section1SelectedCell: T? = nil
    
    public var section2SelectedCell: S? = nil
    
    public var delegate: FirebaseTableViewDelegate? = nil

    public var project: Project? = nil {
        didSet {
            stopSync()
            startSync()
        }
    }
    
    public init(objectDataSources: (FirebaseDataSource<T>, FirebaseDataSource<S>?), project: Project? = nil) {
        self.objectDataSources = objectDataSources
        
        if let _ = objectDataSources.1 {
            kNumberOfSectionsInTableView = 2
        }

        self.project = project

    }

    public func startSync() {
        objectDataSources.0.startSync()
        objectDataSources.1?.startSync()
    }
    
    public func stopSync() {
        objectDataSources.0.stopSync()
        objectDataSources.1?.stopSync()
    }
    
    public func numberOfItemsInSection(section : Int) -> Int {

        return section == 0 ? objectDataSources.0.count : objectDataSources.1?.count ?? 0
        
    }
    
    public func numberOfSectionsInCollectionView() -> Int {
        
        return kNumberOfSectionsInTableView
        
    }
    
    public func didSelectCell(at indexPath: IndexPath) {
        if indexPath.section == 0 {
            section1SelectedCell = objectDataSources.0.list[indexPath.row]
        } else {
            section2SelectedCell = objectDataSources.1?.list[indexPath.row]
        }
    }
    
    public func delete(from tableView: UITableView, at indexPath: IndexPath) {
        if indexPath.section == 0 {
            objectDataSources.0.remove(at: indexPath.row)
        } else {
            objectDataSources.1?.remove(at: indexPath.row)
        }
    }

}

extension PViewModel: FirebaseDataSourceDelegate {
    
    internal func indexAdded<T : FIRDataObject>(at indexPath: IndexPath, data: T) {
        delegate?.indexAdded(at: indexPath, data: data)
    }
    
    internal func indexChanged<T : FIRDataObject>(at indexPath: IndexPath, data: T) {
        delegate?.indexChanged(at: indexPath, data: data)
    }
    
    internal func indexRemoved(at indexPath: IndexPath, key: String) {
        delegate?.indexRemoved(at: indexPath, key: key)
    }
}
