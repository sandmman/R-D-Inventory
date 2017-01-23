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
        
        viewModel.didReceivePart = didReceivePart
        viewModel.didReceiveAssembly = didUpdateAssemblies
        viewModel.didChangeAssembly = didChangeAssembly
        
        instantiateView()
    }
    
    private func instantiateView() {
        guard viewModel.project != nil else {
            return
        }

        self.form = viewModel.instantiateForm()

        instantiateDoneButton()
    }

    private func instantiateDoneButton() {
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(CreateBuildViewController.completedForm(_:)))
        button.title = "Save"
        navigationItem.rightBarButtonItem = button
    }
    
    private func didChangeAssembly(row: PushRow<Assembly>) {
        viewModel.assembly = row.value
        
        guard let section = self.form.allSections.last else {
            return
        }
        
        section.removeAll()
    }

    private func didReceivePart(part: Part, value: Int = 0) {
        guard let section = form.allSections.last else {
            return
        }

        section.append(viewModel.stepperRow(part: part, value: value))
        
        section.reload()
    }
    
    private func didUpdateAssemblies() {
        
        if let cell: PushRow<Assembly> = form.rowBy(tag: Constants.BuildFields.AssemblyID) {
            cell.options = viewModel.assemblies
            cell.reload()
        }
    }

    public func completedForm(_ sender: UIBarButtonItem) {

        guard let _ = viewModel.completed(form: form) else {
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
