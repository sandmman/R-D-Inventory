//
//  InventoryTableViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/1/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class InventoryTableViewController: UITableViewController {
    
    var inventory: [Part] = []
    
    var handles: (UInt, UInt)!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handles = FirebaseDataManager.sharedInstance.listenForParts(onComplete: receivedPart)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        FirebaseDataManager.sharedInstance.removeListener(handle: handles.0)
        FirebaseDataManager.sharedInstance.removeListener(handle: handles.1)
    }
    
    private func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func receivedPart(part: Part) {
        var found = false
        
        for i in 0..<self.inventory.count {
            if part.databaseID == self.inventory[i].databaseID {
                found = true
                self.inventory[i] = part
                break
            }
        }
        
        if !found {
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
            
            FirebaseDataManager.sharedInstance.delete(part: part)
        }
    }
}
