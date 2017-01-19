//
//  FormViewModel.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/12/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit
import Eureka

class FormViewModel<T: FIRDataObject>: NSObject, UITextFieldDelegate {
    
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
    
    public func textRow(for label: String, isRequired: Bool = false) -> TextRow {
        return TextRow(label) {
            $0.add(rule: RuleRequired())
                    $0.title = setDefaultTitle(for: label)
                    $0.placeholder = setDefaultValue(for: label) as? String ?? ""
                    $0.validationOptions = .validatesOnChangeAfterBlurred
                    if isRequired {
                        $0.add(rule: RuleRequired())
                    }
                }.onRowValidationChanged(Validator.onValidationChanged)
    }
    
    public func intRow(for label: String, isRequired: Bool = false) -> IntRow {
        return IntRow(label) {
                    $0.title = setDefaultTitle(for: label)
                    $0.placeholder = setDefaultValue(for: label) as? String ?? ""
                    $0.validationOptions = .validatesOnChangeAfterBlurred
                    $0.add(rule: RuleGreaterOrEqualThan(min: 0))
                    if isRequired {
                        $0.add(rule: RuleRequired())
                    }
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
    
    public func partIDRow(for label: String) -> PartIDRow {
        return PartIDRow(Constants.PartFields.ID){ row in
                    row.title = setDefaultTitle(for: Constants.PartFields.ID)
                    row.placeholder = setDefaultValue(for: Constants.PartFields.ID) as? String ?? ""
                    row.add(rule: RuleRequired())
                    row.add(rule: RegexRule(regExpr: Constants.Patterns.PartID, allowsEmpty: true))
                    row.validationOptions = .validatesOnChangeAfterBlurred
            }.onRowValidationChanged(Validator.onValidationChanged)
            .cellUpdate { cell, row in
                cell.textField.tag = 1
                cell.textField.delegate = self
            }
    }
    
    public func stepperRow(part: Part, value: Int = 0) -> StepperRow {
        return StepperRow(part.key) {
            $0.title = part.name
            $0.value = Double(value)
        }
    }

    public func setDefaultTitle(for label: String) -> String {
        return ""
    }
    
    public func setDefaultValue(for label: String) -> Any {
        return ""
    }

    public func completed(form: Form) -> T? {
        return nil
    }
    
    public func instantiateForm() -> Form {
        return Form()
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let nsString = textField.text as NSString?
        
        let newString = nsString?.replacingCharacters(in: range, with: string)
        
        return Validator.checkPartIDFormat(field: textField, string: string, str: newString)
    }
}

