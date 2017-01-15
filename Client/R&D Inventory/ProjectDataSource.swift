//
//  ProjectDataSource.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/14/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit
import Firebase

class ProjectDataSource<T: FIRDataObject>: FirebaseDataSource<T> {

    var project: Project

    init(section: Int, project: Project) {
        self.project = project

        super.init(section: section, project: project)
    }
    
    override func remove(at index: Int) {
        let obj = syncArray.remove(at: index)
        
        obj.delete()
        project.delete(obj: obj)        
    }
}
