//
//  BuildPartViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/29/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit
import Eureka

public class CreatePartRowViewController: FormViewController, TypedRowControllerType {

    public var row: RowOf<Part>!
    
    public var onDismissCallback: ((UIViewController) -> ())?

    var viewModel: PartFormModel!

    convenience public init(_ callback: ((UIViewController) -> ())?){
        self.init(nibName: nil, bundle: nil)
        onDismissCallback = callback
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        form = viewModel.instantiateForm()

        self.instantiateDoneButton()
    }

    public func completedForm(_ sender: UIBarButtonItem) {
        
        guard let part = viewModel.completed(form: form) else {
            return
        }
        
        row.value = part
    
        onDismissCallback?(self)
    }

    private func instantiateDoneButton() {
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(CreatePartRowViewController.completedForm(_:)))
        button.title = "Save"
        navigationItem.rightBarButtonItem = button
    }

    // Navigation
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        self.tableView?.endEditing(true)

    }
}

