//
//  ProjectViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/3/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit
import Eureka

class CreateProjectViewController: FormViewController {
    
    var project: Project? = nil
    
    @IBOutlet weak var saveProjectButton: UIBarButtonItem!
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard sender === saveProjectButton else {
            return
        }
        
        guard
            let row: TextRow = form.rowBy(tag: Constants.ProjectFields.Name),
            let name = row.value,
            let proj = Project(name: name) else {
                return
        }
        
        project = proj
        
        FirebaseDataManager.save(project: proj)
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.instantiateForm()
    }
    
    private func instantiateForm() {
        form.append(Section("Info"))
        
        let row = TextRow(Constants.ProjectFields.Name){ row in
                row.title = Constants.ProjectFields.Name
                row.placeholder = ""
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
            }
        
        form.allSections.first!.append(row)
        
    }
}
