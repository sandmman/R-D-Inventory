//
//  BuildsViewModel.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/12/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class BuildsViewModel: NSObject {
    
    var buildsDataSource: CalendarDataSource
    
    var selectedCell: Build? = nil
    
    var selectedDate: Date? = nil
    
    public let reloadCollectionViewCallback : (()->())!
    
    let kNumberOfSectionsInTableView = 1
    
    var project: Project {
        didSet {
            stopSync()
            startSync()
            reloadCollectionViewCallback()
        }
    }
    
    public init(project: Project, reloadCollectionViewCallback : @escaping (()->())) {
        
        self.project = project
        
        self.reloadCollectionViewCallback = reloadCollectionViewCallback
        
        buildsDataSource = CalendarDataSource(project: project)

    }

    public func startSync() {
        buildsDataSource.startSync()
    }
    
    public func stopSync() {
        buildsDataSource.stopSync()
    }

    public func getNextViewModel(_ assembly: Assembly? = nil) -> FormViewModel {
        return FormViewModel(project: project, assembly: assembly)
    }

}

extension BuildsViewModel {
    
    public func add(build: Build) {
        reloadCollectionViewCallback()
    }

    public func delete(from tableView: UITableView, at indexPath: IndexPath, with date: Date) {
        
        /*guard let object = buildsDataSource.dict[date.display]?.remove(at: indexPath.row) else {
            return
        }

        tableView.deleteRows(at: [indexPath], with: .fade)
        
        reloadCollectionViewCallback()*/
        
    }
    
}

extension BuildsViewModel {
    
    public func numberOfItemsInSection(section : Int) -> Int {
        guard let selectedDate = selectedDate else {
    
            guard let buildArr = buildsDataSource.dict[Date().display] else {
                return 0
            }

            return buildArr.count
        }

        guard let buildArr = buildsDataSource.dict[selectedDate.display] else {
            return 0
        }

        return buildArr.count
        
    }
    
    public func numberOfSectionsInCollectionView() -> Int {
        
        return kNumberOfSectionsInTableView
        
    }
    
    public func selected(date: Date) {
        selectedDate = date
        
        reloadCollectionViewCallback()
    }

    public func selectedCell(at indexPath: IndexPath) {
        guard let date = selectedDate else {
            return
        }

        selectedCell = buildsDataSource.dict[date.display]?[indexPath.row]
    }
}
