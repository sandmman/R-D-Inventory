//
//  CreatePartViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/1/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit
import Eureka

class CreatePartViewController: FormViewController {
    
    var project: Project!
    
    var viewModel: PartFormModel!

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.instantiateForm()
        self.instantiateDoneButton()
    }
    
    public func completedForm(_ sender: UIBarButtonItem) {
        
        guard viewModel.completed(form: form) else {
            return
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    private func instantiateForm() {

        form = Section("Info")
            <<< viewModel.textRow(for: Constants.PartFields.Name, isRequired: true)
            <<< viewModel.textRow(for: Constants.PartFields.Manufacturer, isRequired: true)
            <<< viewModel.partIDRow(for: Constants.PartFields.ID)
            +++ Section("Detail")
            <<< viewModel.intRow(for: Constants.PartFields.CountInAssembly)
            <<< viewModel.intRow(for: Constants.PartFields.CountInStock)
            <<< viewModel.intRow(for: Constants.PartFields.CountOnOrder)
            <<< viewModel.intRow(for: Constants.PartFields.LeadTime)
    }

    private func instantiateDoneButton() {
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(CreatePartViewController.completedForm(_:)))
        button.title = "Save"
        navigationItem.rightBarButtonItem = button
    }
}
