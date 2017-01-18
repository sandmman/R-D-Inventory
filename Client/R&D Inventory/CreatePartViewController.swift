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
        
        form = viewModel.instantiateForm()

        self.instantiateDoneButton()
    }
    
    public func completedForm(_ sender: UIBarButtonItem) {
        
        guard let _ = viewModel.completed(form: form) else {
            return
        }
        
        _ = navigationController?.popViewController(animated: true)
    }

    private func instantiateDoneButton() {
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(CreatePartViewController.completedForm(_:)))
        button.title = "Save"
        navigationItem.rightBarButtonItem = button
    }
}
