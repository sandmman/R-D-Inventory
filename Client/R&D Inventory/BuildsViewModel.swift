//
//  BuildsViewModel.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/12/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class BuildsViewModel: NSObject {
    
    private(set) var buildsDataSource: CalendarDataSource
    
    fileprivate(set) var selectedCell: Build? = nil
    
    fileprivate(set) var selectedDate: Date!
    
    fileprivate let kNumberOfSectionsInTableView = 1
    
    public var delegate: FirebaseTableViewDelegate?
    
    public var calendarDelegate: CalendarDataSourceDelegate?

    public var project: Project {
        didSet {
            buildsDataSource.updateProject(project: project)
        }
    }
    
    public init(project: Project) {
        
        self.project = project
        
        self.selectedDate = Date()

        buildsDataSource = CalendarDataSource(project: project)
        
        super.init()

        buildsDataSource.delegate = self
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

    }

    public func delete(from tableView: UITableView, at indexPath: IndexPath) {
        
        guard let object = buildsDataSource.remove(at: indexPath.row, for: selectedDate) else {
            return
        }
        
        object.delete()
        
        project.delete(obj: object)

        tableView.deleteRows(at: [indexPath], with: .fade)
        
    }
    
}

extension BuildsViewModel {
    
    public func numberOfItemsInSection(date : Date) -> Int {
        return buildsDataSource.count(date: date.display)
        
    }
    
    public func numberOfSectionsInCollectionView() -> Int {
        
        return kNumberOfSectionsInTableView
        
    }
    
    public func selected(date: Date) {
        selectedDate = date
        calendarDelegate?.reloadTableView()
    }

    public func selectedCell(at indexPath: IndexPath) {
        guard let date = selectedDate else {
            return
        }

        selectedCell = buildsDataSource.dict[date.display]?[indexPath.row]
    }
}

extension BuildsViewModel: FirebaseDictDataSourceDelegate {
    
    internal func indexAdded(at indexPath: IndexPath, data: Build) {
        guard let date = selectedDate, date.display == data.displayDate else {
            calendarDelegate?.reloadCalendar()
            return
        }
        delegate?.indexAdded(at: indexPath, data: data)
    }

    internal func indexChanged(at indexPath: IndexPath, data: Build) {
        guard let date = selectedDate, date.display == data.displayDate else {
            calendarDelegate?.reloadCalendar()
            return
        }
        delegate?.indexChanged(at: indexPath, data: data)
    }
    
    internal func indexRemoved(at indexPath: IndexPath, key: String) {
        delegate?.indexRemoved(at: indexPath, key: key)
    }
}
