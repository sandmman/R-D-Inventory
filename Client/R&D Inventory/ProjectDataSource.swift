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

    init(id: String, project: Project, ref: FIRDatabaseReference) {
        self.project = project

        super.init(id: id, project: project)
    }
    
    override func remove(at index: Int) -> T {
        let obj = syncArray.remove(at: index)
        
        obj.delete()
        project.delete(obj: obj)
        
        return obj
    }
}
