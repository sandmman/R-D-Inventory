//
//  PushRow.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/30/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import Foundation
import Eureka

public final class PartRow: SelectorRow<PushSelectorCell<Part>, CreatePartRowViewController>, RowType {
    
    var project: Project!

    public required init(tag: String?) {
        super.init(tag: tag)
    }
    
    public func setupVC(proj: Project) {

        presentationMode = .show(
            controllerProvider: ControllerProvider.callback {
                
                let vc =  CreatePartRowViewController(){ _ in }
                
                vc.viewModel = PartFormModel(project: proj, assembly: nil)

                return vc
            }, onDismiss: {
                vc in _ = vc.navigationController?.popViewController(animated: true)
        })
        
        displayValueFor = { part in
            return part?.name ?? "unset"
        }
    }
}
