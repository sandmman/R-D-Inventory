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

    override func viewDidLoad() {
        super.viewDidLoad()

        instantiateForm()
        instantiateDoneButton()
    }
    
    private func instantiateForm() {
        
        form = Section("")
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
            +++ Section("")
            <<< DateRow(Constants.BuildFields.Date) {
                $0.title = "Scheduled Date"
            }
            +++ Section("")
            <<< TextAreaRow(Constants.BuildFields.Notes) {
                $0.placeholder = "Notes"
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
