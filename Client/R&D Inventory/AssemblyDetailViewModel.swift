//
//  AssemblyDetailViewModel.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/12/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit
import Firebase

class AssemblyDetailViewModel: PViewModel<Part> {
    
    var parts: AssemblyDataSource<Part>! {
        get { return objectDataSource as! AssemblyDataSource<Part> }
        set { objectDataSource = newValue }
    }
    
    var builds: AssemblyDataSource<Build>!
    
    var assembly: Assembly

    var selectedPart: Part? {
        get { return selectedCell }
        set { selectedCell = newValue }
    }
    
    var selectedBuild: Build? = nil
    
    public init(project: Project, assembly: Assembly, reloadCollectionViewCallback : @escaping (()->())) {
        
        self.assembly = assembly
        
        let dataSource = AssemblyDataSource<Part>(id: Constants.Types.Part, project: project, assembly: assembly)
    
        super.init(objectDataSource: dataSource, callback: reloadCollectionViewCallback, project: project)
        
        kNumberOfSectionsInTableView = 2

        parts = dataSource
        builds = AssemblyDataSource(id: Constants.Types.Build, project: project, assembly: assembly)

        parts.delegate = self
        builds.delegate = self

        
    }
    
    public override func startSync() {
        parts.startSync()
        builds.startSync()
    }
    
    public override func stopSync() {
        parts.stopSync()
        builds.stopSync()
    }

    public func getNextViewModel() -> FormViewModel? {
        return FormViewModel(project: project!, assembly: assembly, parts: parts.list)
    }
    
    public override func delete(from tableView: UITableView, at indexPath: IndexPath) {

        if indexPath.section == 0 {

            builds.remove(at: indexPath.row)

            
        } else {

            parts.remove(at: indexPath.row)
        
        }

        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    
    // MARK: - TableView

    public override func numberOfItemsInSection(section : Int) -> Int {
        
        return section == 0 ? builds.count : parts.count
        
    }
    
    public override func didSelectCell(at indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedBuild = builds.list[indexPath.row]
        } else {
            selectedPart = parts.list[indexPath.row]
        }
    }
}

