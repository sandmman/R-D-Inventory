//
//  BuildDetailViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/31/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit
import Eureka

class BuildDetailViewController: FormViewController {
    
    var build: Build!
    
    var assembly: Assembly? = nil

    var parts: [(Part, Int)] = []

    private var partsNeededTag = "Parts Needed"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instantiateView()
    }
    
    private func instantiateView() {

        instantiateForm()
        instantiateDoneButton()
        
        getParts()
    }
    
    private func getParts() {
        for (key, value) in build.partsNeeded {
            FirebaseDataManager.get(part: key) { part in
                
                self.parts.append((part, value))
                
                guard let section = self.form.allSections.last else {
                    return
                }

                section.append(self.stepperRow(part: part, value: value))
                
                section.reload()
            }
        }
    }

    private func instantiateForm() {
        
        form +++ Section("General")
            <<< TextRow(Constants.BuildFields.Title) {
                $0.title = "Name"
                $0.placeholder = build.title
                $0.validationOptions = .validatesOnChangeAfterBlurred
                }.onRowValidationChanged(Validator.onValidationChanged)
            <<< IntRow(Constants.BuildFields.Quantity) {
                $0.title = "Quantity"
                $0.placeholder = String(build.quantity)
                $0.validationOptions = .validatesOnChangeAfterBlurred
                }.onRowValidationChanged(Validator.onValidationChanged)
            <<< TextRow(Constants.BuildFields.Location) {
                $0.title = "Location"
                $0.placeholder = ""
            }
            <<< DateInlineRow(Constants.BuildFields.Date) {
                $0.title = "Scheduled Date"
                $0.value = build.scheduledDate
            }
            <<< SwitchRow("Notification") {
                $0.title = "Receive Notifications"
            }
            <<< SwitchRow(Constants.BuildFields.BType) {
                $0.title = "Custom Build?"
                $0.value = build.type == BuildType.Custom
        }
        
        let partsSection = Section(partsNeededTag) { $0.hidden = "$type == false" }
        
        for (part, value) in parts {
            partsSection.append(stepperRow(part: part, value: value))
        }
        
        form +++ partsSection
        
    }
    
    private func stepperRow(part: Part, value: Int = 0) -> StepperRow {
        return StepperRow(part.key) {
            $0.title = part.name
            $0.value = Double(value)
        }
    }
    
    private func instantiateDoneButton() {
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(CreateBuildViewController.completedForm(_:)))
        button.title = "Save"
        navigationItem.rightBarButtonItem = button
    }
    
    public func completedForm(_ sender: UIBarButtonItem){
        
        let segue = Constants.Segues.ProjectDetail
        
        self.performSegue(withIdentifier: segue, sender: self)
    }
    
    // MARK: - Navigation
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        self.tableView?.endEditing(true)
    }

}
