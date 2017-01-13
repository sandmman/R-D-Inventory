//
//  AssemblyDetailViewModel.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/12/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class AssemblyDetailViewModel: NSObject {
    
    var parts: [Part] = []
    
    var builds: [Build] = []
    
    var assembly: Assembly

    var selectedPart: Part? = nil
    
    var selectedBuild: Build? = nil
    
    fileprivate let listener = ListenerHandler()

    fileprivate let reloadCollectionViewCallback : (()->())!
    
    fileprivate let kNumberOfSectionsInTableView = 2
    
    var project: Project {
        didSet {
            parts = []
            builds = []
    
            selectedPart = nil
            selectedBuild = nil
    
            reloadCollectionViewCallback()
        }
    }
    
    public init(project: Project, assembly: Assembly, reloadCollectionViewCallback : @escaping (()->())) {
        
        self.project = project
        
        self.assembly = assembly

        self.reloadCollectionViewCallback = reloadCollectionViewCallback

        super.init()
        
        retreiveData()
        
    }
    
    public func retreiveData() {
        listener.listenForObjects(for: project, onComplete: didReceivePart)
        listener.listenForObjects(for: project, onComplete: didReceiveBuild)
    }
    
    public func deinitialize() {
        listener.removeListeners()
    }

    private func didReceivePart(part: Part) {
        
        if let index = parts.index(of: part) {
            
            self.parts[index] = part
            
        } else {
            
            self.parts.append(part)
            
        }
        
        reloadCollectionViewCallback()
    }

    private func didReceiveBuild(build: Build) {
        
        if let index = builds.index(of: build) {
            
            self.builds[index] = build
            
        } else {
            
            self.builds.append(build)
            
        }
        
        reloadCollectionViewCallback()
    }

    public func getNextViewModel() -> FormViewModel {
        return FormViewModel(project: project, assembly: assembly, parts: parts)
    }
}

extension AssemblyDetailViewModel {
    
    public func delete(from tableView: UITableView, at indexPath: IndexPath) {
        if indexPath.section == 0 {

            let object = builds.remove(at: indexPath.row)
    
            object.delete()
            
        } else {

            let object = parts.remove(at: indexPath.row)

            object.delete()
            
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
            selectedBuild = builds[indexPath.row]
        } else {
            selectedPart = parts[indexPath.row]
        }
    }
}
