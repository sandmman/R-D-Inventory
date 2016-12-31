//
//  AssemblyTableViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/27/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit

class AssemblyTableViewController: UITableViewController, AssemblyDelegate {
    
    var selectedAssembly: Assembly? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseDataManager.sharedInstance.delegate = self
    }
    
    public func onItemsAddedToList() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FirebaseDataManager.sharedInstance.assemblies.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCells.assembly, for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = FirebaseDataManager.sharedInstance.assemblies[indexPath.row].name
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let assemblyToDelete = FirebaseDataManager.sharedInstance.assemblies[indexPath.row]

            FirebaseDataManager.sharedInstance.delete(assembly: assemblyToDelete)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        
        selectedAssembly = FirebaseDataManager.sharedInstance.assemblies[indexPath.row]
        
        performSegue(withIdentifier: Constants.Segues.AssemblyDetail, sender: self)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Constants.Segues.AssemblyDetail) {
            
            let viewController = segue.destination as! AssemblyDetailTableViewController
            
            viewController.assembly = selectedAssembly
            
        } else {
        }
    }

    

}
