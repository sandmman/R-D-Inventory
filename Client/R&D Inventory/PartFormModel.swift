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
    
    public var assembly: Assembly? = nil

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

    public override func completed(form: Form) -> Part? {
        
        return isEditing ? updatePart(from: form) : savePart(from: form)
    }
    
    public override func instantiateForm() -> Form {
        return Section("Info")
            <<< textRow(for: Constants.PartFields.Name, isRequired: true)
            <<< textRow(for: Constants.PartFields.Manufacturer, isRequired: true)
            <<< partIDRow(for: Constants.PartFields.ID)
            +++ Section("Detail")
            <<< intRow(for: Constants.PartFields.CountInAssembly)
            <<< intRow(for: Constants.PartFields.CountInStock)
            <<< intRow(for: Constants.PartFields.CountOnOrder)
            <<< intRow(for: Constants.PartFields.LeadTime)
    }
    
    // MARK: - Helpers

    private func updatePart(from form: Form) -> Part? {
        
        guard let oldPart = obj else {
            return nil
        }
        
        guard let newPart = ObjectMapper.update(part: oldPart, from: form) else {
            return nil
        }

        FirebaseDataManager.update(part: newPart)

        return nil
    }
    
    private func savePart(from form: Form) -> Part? {
        
        guard let part = ObjectMapper.createPart(from: form), let proj = project else {
            return nil
        }

        FirebaseDataManager.save(part: part, to: proj)

        return part
    }
}
