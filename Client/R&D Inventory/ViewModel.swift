//
//  ViewModel.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/12/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class ViewModel<T: FIRDataObject>: PViewModel<T, T> {

    public init(project: Project, section: Int) {
        
        let dataSource = ProjectDataSource<T>(section: section, project: project)

        super.init(objectDataSources: (dataSource, nil), project: project)
        
        objectDataSources.0.delegate = self
    }
    
    public init(section: Int) {
        
        let dataSource = FirebaseDataSource<T>(section: section)
        
        super.init(objectDataSources: (dataSource, nil))
        
        objectDataSources.0.delegate = self
    }
}


