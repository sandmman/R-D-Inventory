//
//  BuildsViewModel.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/12/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

import UIKit

class BuildsViewModel: NSObject {
    
    var builds = [String: [Build]]()
    
    var selectedCell: Build? = nil
    
    var selectedDate: Date? = nil

    internal let listener: ListenerHandler!
    
    public let reloadCollectionViewCallback : (()->())!
    
    let kNumberOfSectionsInTableView = 1
    
    var project: Project {
        didSet {
            builds = [:]
            
            deinitialize()
            listenForObjects()
            reloadCollectionViewCallback()
        }
    }
    
    public init(project: Project, reloadCollectionViewCallback : @escaping (()->())) {
        
        self.project = project
        
        self.reloadCollectionViewCallback = reloadCollectionViewCallback
        
        listener = ListenerHandler()
        
        super.init()
        
        listenForObjects()
        
    }

    public func listenForObjects() {
        builds = [:]
        reloadCollectionViewCallback()
        listener.listenForObjects(for: project, onComplete: didReceive)
    }
    
    public func deinitialize() {
        listener.removeListeners()
    }
    
    private func didReceive(result: ObserverResult<Build>) {
        switch result {
        case .added(_): break
        case .changed(let build): didUpdate(build: build)
        case .removed(let ref):
            for (k,value) in builds {
                builds[k] = value.filter { $0.ref != ref}
            }
            listener.removeListeners(to: ref)
        }
        
        reloadCollectionViewCallback()
    }
    
    private func didUpdate(build: Build) {
        if var arr = builds[build.displayDate] {
            if let index = arr.index(of: build) {
                arr[index] = build
            } else {
                arr.append(build)
            }
            builds[build.displayDate] = arr
            
        } else {
            builds[build.displayDate] = [build]
        }
    }

    public func getNextViewModel(_ assembly: Assembly? = nil) -> FormViewModel {
        return FormViewModel(project: project, assembly: assembly)
    }

}

extension BuildsViewModel {
    
    public func add(build: Build) {
        if builds[build.displayDate] == nil {
            
            builds[build.displayDate] = [build]
    
        } else {
           
            builds[build.displayDate]?.append(build)

        }
        
        reloadCollectionViewCallback()
    }

    public func delete(from tableView: UITableView, at indexPath: IndexPath, with date: Date) {

        guard let object = builds[date.display]?.remove(at: indexPath.row) else {
            return
        }
        
        object.delete()
        
        project.delete(obj: object)

        tableView.deleteRows(at: [indexPath], with: .fade)
        
        reloadCollectionViewCallback()
        
    }
    
}

extension BuildsViewModel {
    
    public func numberOfItemsInSection(section : Int) -> Int {
        guard let selectedDate = selectedDate else {
    
            guard let buildArr = builds[Date().display] else {
                return 0
            }

            return buildArr.count
        }

        guard let buildArr = builds[selectedDate.display] else {
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

        selectedCell = builds[date.display]?[indexPath.row]
    }
}
