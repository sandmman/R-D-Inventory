//
//  InventoryTableViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/1/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class InventoryTableViewController: UITableViewController, TabBarViewController {
    
    var inventory = [Part]()
    
    var listener: ListenerHandler!
    
    var project: Project!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listener = ListenerHandler()
        listener.listenForParts(onComplete: didReceivedPart)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        listener.removeListeners()
    }

    public func didChangeProject(project: Project) {
        self.project = project
        inventory = []
    }

    private func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func didReceivedPart(part: Part) {
        if let index = inventory.index(of: part) {
            self.inventory[index] = part
        } else {
            self.inventory.append(part)
        }
        
        self.reloadTable()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventory.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCells.Part, for: indexPath) as! PartTableViewCell

        cell.textLabel?.text = inventory[indexPath.row].name
        cell.detailTextLabel?.text = String(inventory[indexPath.row].countInStock)
        cell.partCountLabel.text = String(inventory[indexPath.row].countInStock)

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            let part = inventory[indexPath.row]
            
            inventory.remove(at: indexPath.row)
            
            FirebaseDataManager.delete(part: part)
        }
    }
}
