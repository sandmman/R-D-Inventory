//
//  AssemblyTableViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/27/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit

class AssemblyTableViewController: UITableViewController {
    
    var assemblies: [Assembly] = []
    
    var selectedAssembly: Assembly? = nil

    @IBAction func unwindToAssemblyList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddAssemblyViewController,
           let assembly = sourceViewController.assembly {

            // Add a new assembly.
            let newIndexPath = IndexPath(row: assemblies.count, section: 0)
            
            assemblies.append(assembly)

            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.assemblies.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCells.assembly, for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = self.assemblies[indexPath.row].name
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        
        selectedAssembly = assemblies[indexPath.row]
        
        performSegue(withIdentifier: Constants.Segues.AssemblyDetail, sender: self)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Constants.Segues.AssemblyDetail) {
            
            let viewController = segue.destination as! AssemblyDetailViewController
            
            viewController.assembly = selectedAssembly
            
        } else {
        }
    }

    

}
