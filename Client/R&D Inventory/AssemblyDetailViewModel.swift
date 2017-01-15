//
//  AssemblyDetailViewModel.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/12/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit
import Firebase

class AssemblyDetailViewModel: PViewModel<Part, Build> {
    
    var parts: AssemblyDataSource<Part>! {
        return objectDataSources.0 as! AssemblyDataSource<Part>
    }
    
    var builds: AssemblyDataSource<Build>! {
        return objectDataSources.1 as! AssemblyDataSource<Build>
    }
    
    var assembly: Assembly

    var selectedPart: Part? {
        return section1SelectedCell
    }

    var selectedBuild: Build? {
        return section2SelectedCell
    }
    
    public init(project: Project, assembly: Assembly) {
        
        self.assembly = assembly
        
        let partDataSource = AssemblyDataSource<Part>(section: 0, project: project, assembly: assembly)
        let buildDataSource = AssemblyDataSource<Build>(section: 1, project: project, assembly: assembly)
    
        super.init(objectDataSources: (partDataSource, buildDataSource), project: project)

        partDataSource.delegate = self
        buildDataSource.delegate = self
    }

    public func getNextViewModel() -> FormViewModel? {
        return FormViewModel(project: project!, assembly: assembly, parts: parts.list)
    }
}

