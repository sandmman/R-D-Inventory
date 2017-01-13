//
//  FormViewModel.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/12/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class FormViewModel: NSObject {
    
    var project: Project!
    
    var assembly: Assembly? = nil

    var assemblies = [Assembly]()
    
    var parts = [Part]()
    
    var generic = false

    var assemblyCallback: (() -> ())? = nil

    public init(project: Project, assemblyCallback: @escaping ()->()) {
        
        self.project = project
        
        self.assemblyCallback = assemblyCallback

        super.init()
        
        retrieveData()
        
    }
    
    public init(project: Project, assembly: Assembly, assemblyCallback: @escaping ()->()) {
        
        self.project = project
        
        self.assembly = assembly

        self.assemblyCallback = assemblyCallback
        
        super.init()
        
        retrieveData()
        
    }
    
    public init(project: Project, assembly: Assembly, parts: [Part]) {
        
        self.project = project
        
        self.assembly = assembly
        
        self.parts = parts
        
        super.init()

        retrieveData()
    }

    public init(project: Project, assembly: Assembly?) {
        self.generic = assembly == nil
        
        self.assembly = assembly

        self.project = project
        
        super.init()

        retrieveData()
    }

    public func retrieveData() {
        FirebaseDataManager.getAssemblies(for: project, onComplete: didReceive)
    }
    
    public func defaultAssembly() -> Assembly? {
        if let assem = assembly {
            return assem
        }
        return assemblies.count > 0 ? assemblies[0] : nil
    }

    private func didReceive(assembly: Assembly) {
        assemblies.append(assembly)
        
        assemblyCallback?()
    }
}
