//
//  AddPartViewController
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/27/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit

class AddPartViewController: UIViewController {

    // Buttons
    @IBOutlet weak var saveAssemblyPart: UIBarButtonItem!
    
    @IBOutlet weak var cancel: UIBarButtonItem!
    
    // Part Fields
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var manufacturerTextField: UITextField!
    @IBOutlet weak var leadTimeTextField: UITextField!
    @IBOutlet weak var countSubPartsTextField: UITextField!
    @IBOutlet weak var countInStockTextField: UITextField!
    @IBOutlet weak var countOnOrderTextField: UITextField!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    var part: Part? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let button = sender as? UIBarButtonItem, button === saveAssemblyPart else {
            return
        }
    
        guard let name = nameTextField.text,
              let id = idTextField.text,
              let manufacturer = manufacturerTextField.text else {
            return
        }

        let leadTime = leadTimeTextField.text != nil ? Date() : Date()
        let subParts = countSubPartsTextField.text != nil ? Int(countSubPartsTextField.text!)! : 0
        let inStock = countInStockTextField.text != nil ? Int(countInStockTextField.text!)! : 0
        let onOrder = countOnOrderTextField.text != nil ? Int(countOnOrderTextField.text!)! : 0

        part = Part(name: name, uid: Int(id)!, manufacturer: manufacturer, leadTime: leadTime, countSubParts: subParts, countInStock: inStock, countOnOrder: onOrder)
        
        guard let p = part else {
            return
        }
        
        DataService.sharedInstance.addPart(part: p)
    }
}
