//
//  FormViewModel.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/12/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit
import Eureka

class FormViewModel<T: FIRDataObject>: NSObject {
    
    public var obj: T? = nil
    
    public var isEditing: Bool {
        return obj != nil
    }
    
    public var project: Project? = nil
    
    public init(project: Project, obj: T? = nil) {
        
        self.project = project
        
        self.obj = obj
        
        super.init()
        
    }
    
    public func textRow(for label: String) -> TextRow {
        return TextRow(label) {
                    $0.title = setDefaultTitle(for: label)
                    $0.placeholder = setDefaultValue(for: label) as? String ?? ""
                    $0.validationOptions = .validatesOnChangeAfterBlurred
                }.onRowValidationChanged(Validator.onValidationChanged)
    }
    
    public func intRow(for label: String) -> IntRow {
        return IntRow(label) {
                    $0.title = setDefaultTitle(for: label)
                    $0.placeholder = setDefaultValue(for: label) as? String ?? ""
                    $0.validationOptions = .validatesOnChangeAfterBlurred
                }.onRowValidationChanged(Validator.onValidationChanged)
    }
    
    public func switchRow(for label: String) -> SwitchRow {
        return SwitchRow(label) {
                    $0.title = setDefaultTitle(for: label)
                    $0.value = setDefaultValue(for: label) as? Bool ?? false
                }
    }
    
    public func dateInLineRow(for label: String) -> DateInlineRow {
        return DateInlineRow(label) {
                    $0.title = setDefaultTitle(for: label)
                    $0.value = setDefaultValue(for: label) as? Date ?? Date()
                }
    }

    public func setDefaultTitle(for label: String) -> String {
        return ""
    }
    
    public func setDefaultValue(for label: String) -> Any {
        return ""
    }
    
    public func completed(form: Form) -> Bool {
        return false
    }
}

