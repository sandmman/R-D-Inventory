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
        print("hello")
        guard let part = ObjectMapper.createPart(from: form) else {
            return
        }
        print(part)
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
            }.onRowValidationChanged(Validator.onValidationChanged)
            <<< TextRow(Constants.PartFields.Manufacturer){ row in
                row.title = "Manufacturer"
                row.placeholder = ""
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
            }.onRowValidationChanged(Validator.onValidationChanged)
            <<< PartIDRow(Constants.PartFields.ID){ row in
                row.title = "ID"
                row.placeholder = ""
                row.add(rule: RuleRequired())
                row.add(rule: RegexRule(regExpr: Constants.Patterns.PartID, allowsEmpty: true))
                row.validationOptions = .validatesOnChangeAfterBlurred
                }.onRowValidationChanged(Validator.onValidationChanged)
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
            }.onRowValidationChanged(Validator.onValidationChanged)
            <<< IntRow(Constants.PartFields.CountInStock) {
                $0.title = "# In Stock"
                $0.placeholder = ""
                $0.add(rule: RuleGreaterOrEqualThan(min: 0, msg: "Value Must Be Positive"))
                $0.validationOptions = .validatesOnChangeAfterBlurred
            }.onRowValidationChanged(Validator.onValidationChanged)
            <<< IntRow(Constants.PartFields.CountOnOrder) {
                $0.title = "# On Order"
                $0.placeholder = ""
                $0.add(rule: RuleGreaterOrEqualThan(min: 0, msg: "Value Must Be Positive"))
                $0.validationOptions = .validatesOnChangeAfterBlurred
            }.onRowValidationChanged(Validator.onValidationChanged)
            <<< IntRow(Constants.PartFields.LeadTime) {
                $0.title = "Lead Time for Order (Days)"
                $0.placeholder = ""
                $0.add(rule: RuleGreaterOrEqualThan(min: 0, msg: "Value Must Be Positive"))
                $0.validationOptions = .validatesOnChangeAfterBlurred
            }.onRowValidationChanged(Validator.onValidationChanged)
    }

    private func instantiateDoneButton() {
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(BuildPartViewController.tappedDone(_:)))
        button.title = "Done"
        navigationItem.rightBarButtonItem = button
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let nsString = textField.text as NSString?
        
        let newString = nsString?.replacingCharacters(in: range, with: string)
        
        return Validator.checkPartIDFormat(field: textField, string: string, str: newString)
    }
}
