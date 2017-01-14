//
//  AssemblyDetailViewModel.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/12/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit
import Firebase

class AssemblyDetailViewModel: NSObject {
    
    var parts: AssemblyDataSource<Part>!
    
    var builds: AssemblyDataSource<Build>!
    
    var assembly: Assembly

    var selectedPart: Part? = nil
    
    var selectedBuild: Build? = nil

    fileprivate let reloadCollectionViewCallback : (()->())!
    
    fileprivate let kNumberOfSectionsInTableView = 2
    
    var project: Project {
        didSet {
    
            stopSync()
            startSync()
            reloadCollectionViewCallback()
        }
    }
    
    public init(project: Project, assembly: Assembly, reloadCollectionViewCallback : @escaping (()->())) {
        
        self.project = project
        
        self.assembly = assembly

        self.reloadCollectionViewCallback = reloadCollectionViewCallback
        
        super.init()
        
        parts = AssemblyDataSource(id: Constants.Types.Part, project: project, assembly: assembly)
        builds = AssemblyDataSource(id: Constants.Types.Build, project: project, assembly: assembly)

        parts.delegate = self
        builds.delegate = self

        
    }
    
    public func startSync() {
        parts.startSync()
        builds.startSync()
    }
    
    public func stopSync() {
        parts.stopSync()
        builds.stopSync()
    }

    public func getNextViewModel() -> FormViewModel? {
        return nil
        //return FormViewModel(project: project, assembly: assembly, parts: parts)
    }
}

extension AssemblyDetailViewModel {
    
    public func delete(from tableView: UITableView, at indexPath: IndexPath) {

        if indexPath.section == 0 {

            builds.remove(at: indexPath.row)

            
        } else {

            parts.remove(at: indexPath.row)
        
        }

        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
}

extension AssemblyDetailViewModel {
    
    public func numberOfItemsInSection(section : Int) -> Int {
        
        return section == 0 ? builds.count : parts.count
        
    }
    
    public func numberOfSectionsInCollectionView() -> Int {
        
        return kNumberOfSectionsInTableView
        
    }
    
    public func selectedCell(at indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedBuild = builds.list[indexPath.row]
        } else {
            selectedPart = parts.list[indexPath.row]
        }
    }
}

extension AssemblyDetailViewModel: FirebaseDataSourceDelegate {

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

