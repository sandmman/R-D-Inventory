//
//  CreateAssemblyViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/30/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit
import Eureka

class CreateAssemblyViewController: FormViewController {

    var project: Project!
    
    func save() {
    
        guard let assem = ObjectMapper.createAssembly(from: form), let proj = project else {
            return
        }

        FirebaseDataManager.save(assembly: assem, to: proj)
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instantiateForm()
        instantiateDoneButton()
    }
    
    private func instantiateDoneButton() {
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(CreateAssemblyViewController.save))
        button.title = "Save"
        navigationItem.rightBarButtonItem = button
    }

    private func instantiateForm() {
        form = Section("Info")
                <<< TextRow(Constants.AssemblyFields.Name){ row in
                    row.title = "Name"
                    row.placeholder = ""
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                }
            +++ Section(Constants.AssemblyFields.Parts)
                <<< PartRowBuilder()
    }
    
    private func PartRowBuilder() -> PartRow {
        let partID: String = "Part\(self.form.allSections.last?.count ?? 0)"
        
        let row = PartRow(partID) { row in
                    row.title = "Add Part"
                }.onChange { row in
                    row.title = row.value?.name
                    self.savePart(row: row)
                }

        row.setupVC(proj: project!)

        return row
    }
    
    private func savePart(row: PartRow) {
        row.section?.append(self.PartRowBuilder())
    }
}
