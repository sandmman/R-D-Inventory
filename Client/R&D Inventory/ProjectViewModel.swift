//
//  ProjectViewModel.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/12/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class ProjectViewModel: NSObject {
    
    var warnings = [(Part, Build)]()
    
    var upcomingBuildsDataSource: ProjectDataSource<Build>!
    
    var selectedWarning: (Part, Build)? = nil
    
    var selectedBuild: Build? = nil
    
    fileprivate let reloadCollectionViewCallback : (()->())!
    
    let kNumberOfSectionsInTableView = 2
    
    var project: Project? = nil {
        didSet {
            stopSync()
            startSync()
            reloadCollectionViewCallback()        }
    }
    
    public init(project: Project, reloadCollectionViewCallback : @escaping (()->())) {
        
        self.project = project

        self.reloadCollectionViewCallback = reloadCollectionViewCallback
        
        super.init()

        upcomingBuildsDataSource = ProjectDataSource(id: Constants.Types.Build, project: project)
        upcomingBuildsDataSource.delegate = self
        
    }
    
    public func startSync() {
        upcomingBuildsDataSource.startSync()
    }
    
    public func stopSync() {
        upcomingBuildsDataSource.stopSync()
    }
}

extension ProjectViewModel {
    
    public func delete(from tableView: UITableView, at indexPath: IndexPath) {
        if indexPath.section == 0 {

        } else {
            upcomingBuildsDataSource.remove(at: indexPath.row)

        }
        
        tableView.deleteRows(at: [indexPath], with: .fade)
        
    }
    
}

extension ProjectViewModel {
    
    public func numberOfItemsInSection(section : Int) -> Int {
        
        return section == 0 ? warnings.count : upcomingBuildsDataSource.count
        
    }
    
    public func numberOfSectionsInCollectionView() -> Int {
        
        return kNumberOfSectionsInTableView
        
    }
    
    public func selectedCell(at indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedWarning = warnings[indexPath.row]
        } else {
            selectedBuild = upcomingBuildsDataSource.list[indexPath.row]
        }
    }
}

extension ProjectViewModel: FirebaseDataSourceDelegate {
    
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
