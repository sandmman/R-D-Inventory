//
//  ViewModel.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/12/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class ViewModel<T: FIRDataObject>: PViewModel<T> {

    public init(project: Project, reloadCollectionViewCallback : @escaping (()->())) {
        
        let dataSource = ProjectDataSource<T>(id: "", project: project)

        super.init(objectDataSource: dataSource, callback: reloadCollectionViewCallback, project: project)
        
        objectDataSource.delegate = self
    }
    
    public init(reloadCollectionViewCallback : @escaping (()->())) {
        
        let dataSource = FirebaseDataSource<T>(id: Constants.Types.Project)
        
        super.init(objectDataSource: dataSource, callback: reloadCollectionViewCallback)
        
        objectDataSource.delegate = self
    }
}


