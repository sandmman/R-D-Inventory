//
//  ViewModel.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/12/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class ViewModel<T: FIRDataObject>: NSObject {
    
    var objectDataSource: FirebaseDataSource<T>!
    
    var selectedCell: T? = nil
    
    fileprivate let reloadCollectionViewCallback : (()->())!
    
    let kNumberOfSectionsInTableView = 1

    var project: Project? = nil {
        didSet {
            startSync()
            stopSync()
            reloadCollectionViewCallback()
        }
    }

    public init(project: Project, reloadCollectionViewCallback : @escaping (()->())) {
        
        self.project = project
        
        self.reloadCollectionViewCallback = reloadCollectionViewCallback
        
        super.init()

        objectDataSource = ProjectDataSource(id: "", project: project)
        objectDataSource.delegate = self
    }
    
    public init(reloadCollectionViewCallback : @escaping (()->())) {

        self.reloadCollectionViewCallback = reloadCollectionViewCallback
        
        super.init()
        
        objectDataSource = FirebaseDataSource(id: Constants.Types.Project)
        objectDataSource.delegate = self
        
    }

    public func startSync() {
        objectDataSource.startSync()
    }
    
    public func stopSync() {
        objectDataSource.stopSync()
    }

}

extension ViewModel {

    public func delete(from tableView: UITableView, at indexPath: IndexPath) {
        objectDataSource.remove(at: indexPath.row)
    }

}

extension ViewModel {
    
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

