//
//  BuildPartViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/29/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit
import Eureka

class BuildPartViewController: FormViewController {
    
    var part: Part? = nil
    
    // Buttons
    @IBOutlet weak var saveAssemblyPart: UIBarButtonItem!
    
    @IBOutlet weak var cancel: UIBarButtonItem!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.instantiateForm()
    }
    
    func instantiateForm() {
        form = Section("Info")
            <<< TextRow(Constants.PartFields.Name){ row in
                row.title = "Name"
                row.placeholder = ""
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
            }
            <<< TextRow(Constants.PartFields.Manufacturer){ row in
                row.title = "Manufacturer"
                row.placeholder = ""
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
            }
            <<< IntRow(Constants.PartFields.ID){ row in
                row.title = "ID"
                row.placeholder = "0"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
            }
            +++ Section("Detail")
            <<< IntRow(Constants.PartFields.NumSubParts) {
                $0.title = "# Sub Parts"
                $0.placeholder = ""
            }
            <<< IntRow(Constants.PartFields.NumInStock) {
                $0.title = "# In Stock"
                $0.placeholder = ""
            }
            <<< IntRow(Constants.PartFields.NumOnOrder) {
                $0.title = "# On Order"
                $0.placeholder = ""
            }
            <<< IntRow(Constants.PartFields.LeadTime) {
                $0.title = "Lead Time"
                $0.placeholder = ""
        }
    }
    
    // Navigation
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        self.tableView?.endEditing(true)

        createPart(from: form.values())
    }
    
    private func createPart(from rows: [String: Any?]) {
        part = Part(name: rows[Constants.PartFields.Name]! as? String ?? "",
                    uid: rows[Constants.PartFields.ID]! as? Int ?? -1,
                    manufacturer: rows[Constants.PartFields.Manufacturer]! as? String ?? "",
                    leadTime: Date(),//rows["leadTime"] as! Int,
                    countSubParts: rows[Constants.PartFields.NumSubParts]! as? Int ?? -1,
                    countInStock: rows[Constants.PartFields.NumInStock]! as? Int ?? -1,
                    countOnOrder: rows[Constants.PartFields.NumOnOrder]! as? Int ?? -1)
        
        guard let p = part else {
            return
        }
        DataService.sharedInstance.addPart(part: p)
    }
}

