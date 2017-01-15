//
//  ProjectViewModel.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/12/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class ProjectViewModel: PViewModel<Build, Build> {
    
    var warnings = [(Part, Build)]()
    
    var selectedWarning: (Part, Build)? = nil
    
    var dataSource: ProjectDataSource<Build> {
        return objectDataSources.0 as! ProjectDataSource<Build>
    }

    public init(project: Project, reloadCollectionViewCallback : @escaping (()->())) {
        
        let dataSource = ProjectDataSource<Build>(id: Constants.Types.Build, project: project)
        
        super.init(objectDataSources: (dataSource, nil), project: project)

        dataSource.delegate = self
    }
    
    public override func delete(from tableView: UITableView, at indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        } else {
            dataSource.remove(at: indexPath.row)
            
        }
        
        tableView.deleteRows(at: [indexPath], with: .fade)
        
    }
    
    public override func numberOfSectionsInCollectionView() -> Int {
        return 2
    }

    public override func numberOfItemsInSection(section : Int) -> Int {
        
        return section == 0 ? warnings.count : dataSource.count
        
    }
    
    public override func didSelectCell(at indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedWarning = warnings[indexPath.row]
        } else {
            section2SelectedCell = dataSource.list[indexPath.row]
        }
    }
}

