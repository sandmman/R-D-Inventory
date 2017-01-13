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
    
    var upcoming = [Build]()
    
    var selectedWarning: (Part, Build)? = nil
    
    var selectedBuild: Build? = nil

    private let listener: ListenerHandler!
    
    private let reloadCollectionViewCallback : (()->())!
    
    internal let kNumberOfSectionsInTableView = 2
    
    var project: Project? = nil {
        didSet {
            warnings = []
            upcoming = []

            reloadCollectionViewCallback()
        }
    }
    
    public init(project: Project, reloadCollectionViewCallback : @escaping (()->())) {
        
        self.project = project
        
        self.reloadCollectionViewCallback = reloadCollectionViewCallback
        
        self.listener = ListenerHandler()

        super.init()
        
        listenForObjects()
        
    }
    
    public init(reloadCollectionViewCallback : @escaping (()->())) {
        
        self.reloadCollectionViewCallback = reloadCollectionViewCallback
        
        listener = ListenerHandler()
        
        super.init()
        
        listenForObjects()
        
    }
    
    public func listenForObjects() {
        listener.listenForObjects(for: project, onComplete: didReceive)
    }
    
    public func deinitialize() {
        listener.removeListeners()
    }
    
    private func didReceive(build: Build) {
        
        let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let nextWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())!
    
        if let index = upcoming.index(of: build) {
            
            self.upcoming[index] = build
            
        } else {
            
            if build.scheduledDate < nextWeekDate && build.scheduledDate > yesterdayDate {
                self.upcoming.append(build)
            }
            
        }
        
        reloadCollectionViewCallback()
    }
}

extension ProjectViewModel {
    
    public func delete(from tableView: UITableView, at indexPath: IndexPath) {
        if indexPath.section == 0 {

        } else {
            let object = upcoming.remove(at: indexPath.row)
            
            object.delete()
        }
        
        tableView.deleteRows(at: [indexPath], with: .fade)
        
    }
    
}

extension ProjectViewModel {
    
    public func numberOfItemsInSection(section : Int) -> Int {
        
        return section == 0 ? warnings.count : upcoming.count
        
    }
    
    public func numberOfSectionsInCollectionView() -> Int {
        
        return kNumberOfSectionsInTableView
        
    }
    
    public func selectedCell(at indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedWarning = warnings[indexPath.row]
        } else {
            selectedBuild = upcoming[indexPath.row]
        }
    }
}
