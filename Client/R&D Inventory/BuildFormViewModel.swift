//
//  BuildFormViewModel.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/13/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class BuildFormViewModel: FormViewModelParent {
    
    var assembly: Assembly? = nil
    
    var assemblies = [Assembly]()
    
    var parts = [Part]()
    
    public init(project: Project, assembly: Assembly?, parts: [Part], callback: @escaping ()->()) {
        
        self.assembly = assembly

        super.init(project: project, reloadViewCallback: callback)
    }
    
    convenience init(project: Project, callback: @escaping ()->()) {
        
        self.init(project: project, assembly: nil, parts: [], callback: callback)
    }
    
}
