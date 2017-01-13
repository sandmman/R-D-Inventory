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
    
    var project: Project!
    
    var assembly: Assembly? = nil

    // Generic == true, if build is created from project home
    // Generic == true, if build is created from assembly home
    var generic = false

    var viewModel: FormViewModel!

    private var partsNeededTag = "Parts Needed"

    override func viewDidLoad() {
        super.viewDidLoad()

        instantiateView()
        
        viewModel = FormViewModel(project: project, assemblyCallback: didUpdateAssemblies)
    }
    
    private func instantiateView() {
        guard project != nil else {
            return
        }
        instantiateForm()
        instantiateDoneButton()
    }

    private func didUpdateAssemblies() {
    
        if let cell: PushRow<Assembly> = form.rowBy(tag: Constants.BuildFields.AssemblyID) {
            cell.options = viewModel.assemblies
            cell.reload()
        }
    }

    private func instantiateForm() {
        
        form +++ Section("Please Choose Assembly for Build") {
                $0.hidden = Condition.function([""], { form in
                    return !self.generic
                })
            }
            <<< PushRow<Assembly>(Constants.BuildFields.AssemblyID) {
                $0.title = "Assembly"
                $0.options = viewModel.assemblies
                $0.value = viewModel.defaultAssemblyValue()
                $0.selectorTitle = "Choose an Assembly!"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChangeAfterBlurred
                $0.displayValueFor  = {
                    if let t = $0 {
                        return t.name
                    }
                    return nil
                    }
                }
                .onChange { row in
                
                    self.updateSection(assembly: row.value)
                    
                }
            +++ Section("General")
            <<< TextRow(Constants.BuildFields.Title) {
                $0.title = "Name"
                $0.placeholder = ""
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChangeAfterBlurred
            }.onRowValidationChanged(Validator.onValidationChanged)
            <<< IntRow(Constants.BuildFields.Quantity) {
                $0.title = "Quantity"
                $0.placeholder = ""
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChangeAfterBlurred
            }.onRowValidationChanged(Validator.onValidationChanged)
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
            <<< SwitchRow(Constants.BuildFields.BType) {
                $0.title = "Custom Build?"
                $0.value = false
            }
    
        let partsSection = Section(partsNeededTag) { $0.hidden = "$type == false" }
        
        for part in parts {
            partsSection.append(stepperRow(part: part))
        }
        
        form +++ partsSection
        
    }

    private func updateSection(assembly: Assembly?) {

        guard let section = form.allSections.last else {
            return
        }

        section.removeAll()
        
        guard let assembly = assembly else {
            return
        }

        FirebaseDataManager.getParts(for: assembly, onComplete: didAddPartToSection)
    }
    
    private func didAddPartToSection(part: Part) {
        guard let section = form.allSections.last else {
            return
        }

        parts.append(part)

        section.append(stepperRow(part: part))
        
        section.reload()
    }

    private func stepperRow(part: Part) -> StepperRow {
        return StepperRow(part.key) {
            $0.title = part.name
            $0.value = 0
        }
    }

    private func instantiateDoneButton() {
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(CreateBuildViewController.completedForm(_:)))
        button.title = "Save"
        navigationItem.rightBarButtonItem = button
    }
    
    public func completedForm(_ sender: UIBarButtonItem){

        // Todo Clean this up to work straight from the form without the parts
        guard let build = ObjectMapper.createBuild(from: form, parts: parts), let proj = project else {
            return
        }
        
        newBuild = build
        
        if generic {
            
            guard let row: PushRow<Assembly> = form.rowBy(tag:  Constants.BuildFields.AssemblyID), let val = row.value else {
                return
            }

            FirebaseDataManager.save(build: build, to: val, within: proj)

        } else {

            guard let assem = assembly else { return }

            FirebaseDataManager.save(build: build, to: assem, within: proj)
        }
        
        let segue = generic ? Constants.Segues.UnwindToBuildCalendar : Constants.Segues.UnwindToAssemblyDetail

        self.performSegue(withIdentifier: segue, sender: self)
    }
    
    // Navigation
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        self.tableView?.endEditing(true)
    }
}
