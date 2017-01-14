//
//  ProjectViewModel.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/12/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class ProjectViewModel: PViewModel<Build> {
    
    var warnings = [(Part, Build)]()
    
    var selectedWarning: (Part, Build)? = nil
    
    public init(project: Project, reloadCollectionViewCallback : @escaping (()->())) {
        
        let dataSource = ProjectDataSource<Build>(id: Constants.Types.Build, project: project)
        
        super.init(objectDataSource: dataSource, callback: reloadCollectionViewCallback, project: project)
        
        kNumberOfSectionsInTableView = 2
        
        objectDataSource.delegate = self
    }
    
    public override func delete(from tableView: UITableView, at indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        } else {
            objectDataSource.remove(at: indexPath.row)
            
        }
        
        tableView.deleteRows(at: [indexPath], with: .fade)
        
    }
    
    public override func numberOfItemsInSection(section : Int) -> Int {
        
        return section == 0 ? warnings.count : objectDataSource.count
        
    }
    
    public override func didSelectCell(at indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedWarning = warnings[indexPath.row]
        } else {
            selectedCell = objectDataSource.list[indexPath.row]
        }
    }
}

