//
//  ViewModel.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/12/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class ViewModel<T: FIRDataObject>: NSObject {
    
    var objects = [T]()
    
    var selectedCell: T? = nil

    private let listener: ListenerHandler!
    
    private let reloadCollectionViewCallback : (()->())!
    
    let kNumberOfSectionsInTableView = 1

    var project: Project? = nil {
        didSet {
            objects = []

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
    
    public init(reloadCollectionViewCallback : @escaping (()->())) {

        self.reloadCollectionViewCallback = reloadCollectionViewCallback
        
        listener = ListenerHandler()
        
        super.init()
        
        listenForObjects()
        
    }

    public func listenForObjects() {
        listener.listenForObjects(for: project, onComplete: didReceiveObject)
    }
    
    public func deinitialize() {
        listener.removeListeners()
    }

    private func didReceiveObject(object: T) {
        
        if let index = objects.index(of: object) {

            self.objects[index] = object
    
        } else {
    
            self.objects.append(object)

        }

        reloadCollectionViewCallback()
    }
}

extension ViewModel {

    public func delete(from tableView: UITableView, at indexPath: IndexPath) {
        let object = objects.remove(at: indexPath.row)
        
        object.delete()

        tableView.deleteRows(at: [indexPath], with: .fade)
        
    }

}

extension ViewModel {
    
    public func numberOfItemsInSection(section : Int) -> Int {
        
        return objects.count
        
    }
    
    public func numberOfSectionsInCollectionView() -> Int {
        
        return kNumberOfSectionsInTableView
        
    }
    
    public func selectedCell(at indexPath: IndexPath) {
        selectedCell = objects[indexPath.row]
    }
}
