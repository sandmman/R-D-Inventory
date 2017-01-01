//
//  CreateBuildViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/31/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit
import Eureka

class CreateBuildViewController: FormViewController {
    
    var parts: [Part] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        instantiateForm()
        instantiateDoneButton()
    }
    
    private func instantiateForm() {
        
        form +++ Section("General")
            <<< TextRow(Constants.BuildFields.Title) {
                $0.title = "Name"
                $0.placeholder = ""
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
            }
            <<< TextRow(Constants.BuildFields.Location) {
                $0.title = "Location"
                $0.placeholder = ""
            }
            <<< DateInlineRow(Constants.BuildFields.Date) {
                $0.title = "Scheduled Date"
                $0.value = Date()
            }
            <<< SwitchRow("Notification") {
                $0.title = "Receive Notifications"
            }
            <<< MultipleSelectorRow(Constants.BuildFields.PartsNeeded) {
                $0.options = ["c","b","a"]
            }
    
        let partsSection = Section("Parts Needed")
        
        for part in parts {
            partsSection.append(stepperRow(part: part))
        }
        
        form +++ partsSection
        
    }
    
    private func stepperRow(part: Part) -> StepperRow {
        return StepperRow(part.databaseID) {
            $0.title = part.name
            $0.value = 0
        }
    }

    private func instantiateDoneButton() {
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(CreateBuildViewController.completedForm(_:)))
        button.title = "Add"
        navigationItem.rightBarButtonItem = button
    }
    
    public func completedForm(_ sender: UIBarButtonItem){
        self.performSegue(withIdentifier: "unwindToAssemblyDetail", sender: self)
    }
    
    // Navigation
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        self.tableView?.endEditing(true)
    }
}
