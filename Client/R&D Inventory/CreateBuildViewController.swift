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
    
    public var viewModel: BuildFormViewModel!

    private var partsNeededTag = "Parts Needed"

    override func viewDidLoad() {
        super.viewDidLoad()

        instantiateView()
        
        viewModel.didReceivePart = didReceivePart
        viewModel.didReceiveAssembly = didUpdateAssemblies
    }
    
    private func instantiateView() {
        guard viewModel.project != nil else {
            return
        }

        instantiateForm()
        instantiateDoneButton()
    }

    private func instantiateForm() {
        
        form +++ Section("Please Choose Assembly for Build") {
                $0.hidden = Condition.function([""], { form in
                    return self.viewModel.isEditing
                })
            }
            <<< PushRow<Assembly>(Constants.BuildFields.AssemblyID) {
                $0.title = "Assembly"
                $0.options = viewModel.assemblies
                $0.value = viewModel.assembly
                $0.selectorTitle = "Choose an Assembly!"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChangeAfterBlurred
                $0.displayValueFor = { return $0?.name }
                }
                .onChange { row in
                
                    self.viewModel.assembly = row.value
                    
                    guard let section = self.form.allSections.last else {
                        return
                    }
                    
                    section.removeAll()

                }
            +++ Section("General")
            <<< viewModel.textRow(for: Constants.BuildFields.Title)
            <<< viewModel.intRow(for: Constants.BuildFields.Quantity)
            <<< viewModel.textRow(for: Constants.BuildFields.Location)
            <<< viewModel.dateInLineRow(for: Constants.BuildFields.Date)
            <<< viewModel.switchRow(for: Constants.BuildFields.Notifications)
            <<< viewModel.switchRow(for: Constants.BuildFields.BType)
    
        let partsSection = Section(partsNeededTag) { $0.hidden = "$type == false" }
        
        for part in viewModel.parts {
            partsSection.append(stepperRow(part: part))
        }
        
        form +++ partsSection
        
    }
    
    private func instantiateDoneButton() {
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(CreateBuildViewController.completedForm(_:)))
        button.title = "Save"
        navigationItem.rightBarButtonItem = button
    }

    private func didReceivePart(part: Part, value: Int = 0) {
        guard let section = form.allSections.last else {
            return
        }

        section.append(stepperRow(part: part, value: value))
        
        section.reload()
    }
    
    private func didUpdateAssemblies() {
        
        if let cell: PushRow<Assembly> = form.rowBy(tag: Constants.BuildFields.AssemblyID) {
            cell.options = viewModel.assemblies
            cell.reload()
        }
    }

    private func stepperRow(part: Part, value: Int = 0) -> StepperRow {
        return StepperRow(part.key) {
            $0.title = part.name
            $0.value = Double(value)
        }
    }

    public func completedForm(_ sender: UIBarButtonItem) {

        guard viewModel.completed(form: form) else {
            return
        }

        _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        self.tableView?.endEditing(true)
    }
}
