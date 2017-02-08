//
//  ProjectViewModel.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/12/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class ProjectViewModel: PViewModel<Warning, Build> {
    
    fileprivate(set) var selectedWarning: Warning? = nil
    
    fileprivate(set) var selectedBuild: Build? = nil

    var warningDataSource: ProjectDataSource<Warning> {
        return objectDataSources.0 as! ProjectDataSource<Warning>
    }

    var buildDataSource: ProjectDataSource<Build> {
        return objectDataSources.1 as! ProjectDataSource<Build>
    }

    public init(project: Project, section: Int) {
        
        let warningDataSource = ProjectDataSource<Warning>(section: section, project: project)
        
        let buildDataSource = ProjectDataSource<Build>(section: section, project: project)
        
        super.init(objectDataSources: (warningDataSource, buildDataSource), project: project)

        warningDataSource.delegate = self
        buildDataSource.delegate = self
    }
    
    public func retrieveItem(at indexPath: IndexPath) -> TableViewCompatible {
        return indexPath.section == 0 ?
            warningDataSource.list[indexPath.row]
            :
            buildDataSource.list[indexPath.row]
    }

    public override func delete(from tableView: UITableView, at indexPath: IndexPath) {
        if indexPath.section == 1 {
            buildDataSource.remove(at: indexPath.row)
        }
        
        tableView.deleteRows(at: [indexPath], with: .fade)
        
    }
    
    public override func numberOfSectionsInCollectionView() -> Int {
        return 2
    }

    public override func numberOfItemsInSection(section : Int) -> Int {
        
        return section == 0 ? warningDataSource.count : buildDataSource.count
        
    }
    
    public override func didSelectCell(at indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedWarning = warningDataSource.list[indexPath.row]
        } else {
            selectedBuild = buildDataSource.list[indexPath.row]
        }
    }
}

