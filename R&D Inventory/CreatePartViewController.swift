//
//  CreatePartViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/1/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit
import Eureka

class CreatePartViewController: FormViewController, UITextFieldDelegate {

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.instantiateForm()
        self.instantiateDoneButton()
    }
    
    public func tappedDone(_ sender: UIBarButtonItem) {

        guard let part = ObjectMapper.createPart(from: form) else {
            return
        }

        FirebaseDataManager.sharedInstance.add(part: part)
        
        navigationController?.popViewController(animated: true)        
    }
    
    private func instantiateForm() {

        form = Section("Info")
            <<< TextRow(Constants.PartFields.Name){ row in
                row.title = "Name"
                row.placeholder = ""
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
            }.onRowValidationChanged(onValidationChanged)
            <<< TextRow(Constants.PartFields.Manufacturer){ row in
                row.title = "Manufacturer"
                row.placeholder = ""
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
            }.onRowValidationChanged(onValidationChanged)
            <<< IntRow(Constants.PartFields.ID){ row in
                row.title = "ID"
                row.placeholder = ""
                row.add(rule: RuleRequired())
                row.add(rule: RegexRule(regExpr: Constants.Patterns.PartID, allowsEmpty: true))
                row.validationOptions = .validatesOnChangeAfterBlurred
            }.onRowValidationChanged(onValidationChanged)
            .cellUpdate { cell, row in
                cell.textField.tag = 1
                cell.textField.delegate = self
            }

            +++ Section("Detail")
            <<< IntRow(Constants.PartFields.CountInAssembly) {
                $0.title = "# in Assembly"
                $0.placeholder = ""
                $0.add(rule: RuleGreaterOrEqualThan(min: 0, msg: "Value Must Be Positive"))
                $0.validationOptions = .validatesOnChangeAfterBlurred
            }.onRowValidationChanged(onValidationChanged)
            <<< IntRow(Constants.PartFields.CountInStock) {
                $0.title = "# In Stock"
                $0.placeholder = ""
                $0.add(rule: RuleGreaterOrEqualThan(min: 0, msg: "Value Must Be Positive"))
                $0.validationOptions = .validatesOnChangeAfterBlurred
            }.onRowValidationChanged(onValidationChanged)
            <<< IntRow(Constants.PartFields.CountOnOrder) {
                $0.title = "# On Order"
                $0.placeholder = ""
                $0.add(rule: RuleGreaterOrEqualThan(min: 0, msg: "Value Must Be Positive"))
                $0.validationOptions = .validatesOnChangeAfterBlurred
            }.onRowValidationChanged(onValidationChanged)
            <<< IntRow(Constants.PartFields.LeadTime) {
                $0.title = "Lead Time for Order (Days)"
                $0.placeholder = ""
                $0.add(rule: RuleGreaterOrEqualThan(min: 0, msg: "Value Must Be Positive"))
                $0.validationOptions = .validatesOnChangeAfterBlurred
            }.onRowValidationChanged(onValidationChanged)
    }
    
    private func onValidationChanged(cell: TextCell, row: TextRow) {
         if !row.isValid {
            for (_, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                row.placeholder = validationMsg
                row.placeholderColor = UIColor.red
            }
        }
    }
    
    private func onValidationChanged(cell: IntCell, row: IntRow) {
        let rowIndex = row.indexPath!.row
        while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
            row.section?.remove(at: rowIndex + 1)
        }
        if !row.isValid {
            for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                let labelRow = LabelRow() {
                    $0.title = validationMsg
                    $0.cell.height = { 30 }
                }
                row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
            }
        }
    }

    private func instantiateDoneButton() {
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(BuildPartViewController.tappedDone(_:)))
        button.title = "Done"
        navigationItem.rightBarButtonItem = button
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let nsString = textField.text as NSString?
        
        let newString = nsString?.replacingCharacters(in: range, with: string)
        
        return checkPartIDFormat(field: textField, string: string, str: newString)
    }
    
    public func checkPartIDFormat(field: UITextField, string: String?, str: String?) -> Bool {
        
        if string == "" {
            
            return true
            
        } else if str!.characters.count == 4 {
            
            field.text = field.text! + "-"
            
        } else if str!.characters.count == 10 {
            
            field.text = field.text! + "-"
            
        } else if str!.characters.count > 12 {
            
            return false
        }
        
        return true
    }
}
