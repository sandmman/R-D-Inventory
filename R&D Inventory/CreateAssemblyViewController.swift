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
    
    var assembly: Assembly? = nil

    @IBOutlet weak var saveAssemblyButton: UIBarButtonItem!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard sender === saveAssemblyButton else {
            return
        }
        
        guard
            let row: TextRow = form.rowBy(tag: "Name"),
            let name = row.value,
            let a = Assembly(name: name, parts: self.getAssemblyParts()) else {
            return
        }
        
        assembly = a
        
        FirebaseDataManager.add(assembly: a)
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.instantiateForm()
    }
    
    private func instantiateForm() {
        form = Section("Info")
                <<< TextRow("Name"){ row in
                    row.title = "Name"
                    row.placeholder = ""
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
                }
            +++ Section("Parts")
                <<< PartRowBuilder()
    }
    
    private func PartRowBuilder() -> PartRow {
        let partID: String = "Part\(self.form.allSections.last?.count ?? 0)"

        return PartRow(partID) { row in
                row.title = "Add Part"
            }.onChange { row in
                row.title = row.value?.name
                self.savePart(row: row)
            }
    }
    
    private func savePart(row: PartRow) {
        row.section?.append(self.PartRowBuilder())
    }
    
    // Helper

    private func getAssemblyParts() -> [String: Int] {
        
        guard let partRows = form.allSections.last else {
            return [:]
        }
        return partRows.reduce([String: Int](), createPartDict)
    }

    private func createPartDict(dict: [String: Int], nextPartRow: BaseRow) -> [String: Int] {
        guard let partRow = nextPartRow as? PartRow, let part = partRow.value else {
            return dict
        }
        
        var dict = dict

        dict[part.key] = part.countInAssembly

        return dict
        
    }
}
