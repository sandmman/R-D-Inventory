//
//  AssemblyDataSource.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/14/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit
import Firebase

class AssemblyDataSource<T: FIRDataObject>: FirebaseDataSource<T>  {
    
    var project: Project
    
    var assembly: Assembly

    init(id: String, project: Project, assembly: Assembly) {
        self.project = project
        
        self.assembly = assembly

        super.init(id: id, project: project, assembly: assembly)
    }
    
    override func remove(at index: Int) -> T {
        let obj = syncArray.remove(at: index)

        obj.delete()
        project.delete(obj: obj)

        return obj
    }
}
