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
        let errors = form.validate()
        if errors.count == 0 {
            print(errors)
        } else {
            row.value = self.createPart(from: form.values())
            onDismissCallback?(self)
        }
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

        return checkPartIDFormat(field: textField, string: string, str: newString)
    }

    public func checkPartIDFormat(field: UITextField, string: String?, str: String?) -> Bool {

        if string == "" {
            
            return true
            
        } else if str!.characters.count == 4 {
            
            field.text = field.text! + "-"
            
        } else if str!.characters.count == 10 {
            
            field.text = field.text! + "-"
            
        } else if str!.characters.count > 14 {
            
            return false
        }
        
        return true
    }

    private func createPart(from rows: [String: Any?]) -> Part? {
        guard let part = Part(name: rows[Constants.PartFields.Name]! as? String ?? "",
                    uid: rows[Constants.PartFields.ID]! as? Int ?? -1,
                    manufacturer: rows[Constants.PartFields.Manufacturer]! as? String ?? "",
                    leadTime: rows[Constants.PartFields.LeadTime]! as? Int ?? -1,
                    countInAssembly: rows[Constants.PartFields.CountInAssembly]! as? Int ?? -1,
                    countInStock: rows[Constants.PartFields.CountInStock]! as? Int ?? -1,
                    countOnOrder: rows[Constants.PartFields.CountOnOrder]! as? Int ?? -1) else {
            return nil
        }
        
        FirebaseDataManager.sharedInstance.add(part: part)
        
        return part
        
    }

    // Navigation
    
    // This method lets you configure a view controller before it's presented.
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        self.tableView?.endEditing(true)

        _ = createPart(from: form.values())
    }
}

