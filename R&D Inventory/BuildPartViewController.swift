//
//  BuildPartViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/29/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit
import Eureka

public class BuildPartViewController: FormViewController, TypedRowControllerType, UITextFieldDelegate {

    public var row: RowOf<Part>!
    
    public var onDismissCallback: ((UIViewController) -> ())?

    convenience public init(_ callback: ((UIViewController) -> ())?){
        self.init(nibName: nil, bundle: nil)
        onDismissCallback = callback
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.instantiateForm()
        self.instantiateDoneButton()
    }
    
    public func tappedDone(_ sender: UIBarButtonItem) {

        guard let part = ObjectMapper.createPart(from: form) else {
            return
        }

        row.value = part

        FirebaseDataManager.add(part: part)

        onDismissCallback?(self)
    }

    private func instantiateForm() {
        
        var part: Part? = nil
        
        if let value = row.value {
            part = value as Part
        }

        form = Section("Info")
            <<< TextRow(Constants.PartFields.Name){ row in
                row.title = "Name"
                row.placeholder = part?.name ?? ""
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
            }
            <<< TextRow(Constants.PartFields.Manufacturer){ row in
                row.title = "Manufacturer"
                row.placeholder = part?.manufacturer ?? ""
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
            }
            <<< IntRow(Constants.PartFields.ID){ row in
                row.title = "ID"
                row.placeholder = part?.uid.description ?? ""
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
            }.cellUpdate { cell, row in
                cell.textField.tag = 1
                cell.textField.delegate = self
                
            }
            +++ Section("Detail")
            <<< IntRow(Constants.PartFields.CountInAssembly) {
                $0.title = "# in Assembly"
                $0.placeholder = part?.countInAssembly.description ?? ""
                $0.add(rule: RuleGreaterThan(min: 0, msg: "Count must be greater than 0"))
                $0.validationOptions = .validatesOnChangeAfterBlurred
            }
            <<< IntRow(Constants.PartFields.CountInStock) {
                $0.title = "# In Stock"
                $0.placeholder = part?.countInStock.description ?? ""
                $0.add(rule: RuleGreaterThan(min: 0, msg: "Count must not be negative"))
                $0.validationOptions = .validatesOnChangeAfterBlurred
            }
            <<< IntRow(Constants.PartFields.CountOnOrder) {
                $0.title = "# On Order"
                $0.placeholder = part?.countOnOrder.description ?? ""
                $0.add(rule: RuleGreaterThan(min: 0, msg: "Count must not be negative"))
                $0.validationOptions = .validatesOnChangeAfterBlurred
            }
            <<< IntRow(Constants.PartFields.LeadTime) {
                $0.title = "Lead Time for Order (Days)"
                $0.placeholder = part?.leadTime.description ?? ""
                $0.add(rule: RuleGreaterThan(min: 0, msg: "Count must not be negative"))
                $0.validationOptions = .validatesOnChangeAfterBlurred
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

        return Validator.checkPartIDFormat(field: textField, string: string, str: newString)
    }

    // Navigation
    
    // This method lets you configure a view controller before it's presented.
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        self.tableView?.endEditing(true)

        //_ = createPart(from: form.values())
    }
}

