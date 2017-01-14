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

    init(id: String, project: Project, assembly: Assembly, ref: FIRDatabaseReference) {
        self.project = project
        
        self.assembly = assembly

        super.init(id: id, ref: ref)
    }
}
