//
//  PartFormModel.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/18/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import Foundation
import Eureka

class PartFormModel: FormViewModel<Part> {
    
    public var assembly: Assembly? = nil {
        didSet {
            guard let assem = assembly else {
                return
            }
        }
    }

    public var didReceivePart: (((Part, Int)) -> ())? = nil
    
    public var didReceiveAssembly: (() -> ())? = nil
    
    // MARK: - Initializers
    
    public init(project: Project, assembly: Assembly?, part: Part? = nil) {
        
        self.assembly = assembly
        
        super.init(project: project, obj: part)
    
    }
    
    // MARK: - Form Overrides
    
    override func setDefaultValue(for label: String) -> Any {

        switch label {
        case Constants.PartFields.Name            : return isEditing ? obj!.name            : ""
        case Constants.PartFields.Manufacturer    : return isEditing ? obj!.manufacturer    : ""
        case Constants.PartFields.ID              : return isEditing ? obj!.key             : ""
        case Constants.PartFields.CountInAssembly : return isEditing ?
                                                        String(obj!.countInAssembly) : "0"
        case Constants.PartFields.CountInStock    : return isEditing ?
                                                        String(obj!.countInStock)    : "0"
        case Constants.PartFields.CountOnOrder    : return isEditing ?
                                                        String(obj!.countOnOrder)    : "0"
        case Constants.PartFields.LeadTime        : return isEditing ?
                                                        String(obj!.leadTime)        : "0"
        default                                   : return ""
        }
    }
    
    override func setDefaultTitle(for label: String) -> String {
        
        switch label {
        case Constants.PartFields.Name            : return "Name"
        case Constants.PartFields.Manufacturer    : return "Manufacturer"
        case Constants.PartFields.ID              : return "Identifier"
        case Constants.PartFields.CountInAssembly : return "# in Assembly"
        case Constants.PartFields.CountInStock    : return "# in Stock"
        case Constants.PartFields.CountOnOrder    : return "# on Order"
        case Constants.PartFields.LeadTime        : return "Lead Time (days)"
        default                                   : return ""
        }
    }

    public override func completed(form: Form) -> Bool {
        
        return isEditing ? updatePart(from: form) : savePart(from: form)
    }
    
    private func updatePart(from form: Form) -> Bool {
        return true
    }
    
    private func savePart(from form: Form) -> Bool {
        
        guard let part = ObjectMapper.createPart(from: form), let proj = project else {
            return false
        }
        
        FirebaseDataManager.save(part: part, to: proj)

        return true
    }
}
