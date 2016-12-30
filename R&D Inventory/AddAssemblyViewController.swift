//
//  AddAssemblyViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/27/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit

class AddAssemblyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate {
    
    var assembly: Assembly? = nil
    
    var parts: [Part] = []

    private var selectedCell: Part? = nil

    @IBOutlet weak var addPartButton: UIBarButtonItem!
    
    @IBOutlet weak var saveAssemblyButton: UIBarButtonItem!
   
    @IBOutlet weak var cancelButton: UIBarButtonItem!

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var partsTableView: UITableView!
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let button = sender as? UIBarButtonItem, button === saveAssemblyButton else {
            return
        }
        
        let name = nameTextField.text ?? ""

        assembly = Assembly(name: name, parts: parts.reduce([String]()) {
            arr, part in
            var arr = arr
            arr.append(part.databaseID)
            return arr
        })
        
        guard let a = assembly else {
            return
        }
        
        DataService.sharedInstance.addAssembly(assembly: a)
        
        dismiss(animated: true, completion: nil)
    }

    @IBAction func unwindToAssemblyBuilder(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? BuildPartViewController,
            let part = sourceViewController.part {

            // Add a new assembly.
            let newIndexPath = IndexPath(row: parts.count, section: 0)
            
            parts.append(part)

            partsTableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        partsTableView.delegate = self
        partsTableView.dataSource = self
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveAssemblyButton.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if (segue.identifier == Constants.Segues.PartDetail) {

            let viewController = segue.destination as! PartViewController

            viewController.part = selectedCell

        }
    }
    
    // Table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.parts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.partsTableView.dequeueReusableCell(withIdentifier: Constants.TableViewCells.part)! as UITableViewCell
        
        cell.textLabel?.text = self.parts[indexPath.row].name
        cell.detailTextLabel?.text = self.parts[indexPath.row].manufacturer
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        
        selectedCell = parts[indexPath.row]

        performSegue(withIdentifier: Constants.Segues.PartDetail, sender: self)
    }
}
