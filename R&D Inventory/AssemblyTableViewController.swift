//
//  AssemblyTableViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/27/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit

class AssemblyTableViewController: UITableViewController {
    
    var project: Project!
    
    var listener: ListenerHandler!

    var selectedAssembly: Assembly? = nil
    
    var assemblies = [Assembly]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listener = ListenerHandler()
        listener.listenForAssemblies(for: project, onComplete: receivedAssembly)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        listener.removeListeners()
    }
    
    private func receivedAssembly(assembly: Assembly) {
        var found = false
        
        for i in 0..<self.assemblies.count {
            if assembly.key == self.assemblies[i].key {
                found = true
                self.assemblies[i] = assembly
                break
            }
        }
        
        if !found {
            self.assemblies.append(assembly)
        }
        
        self.reloadTable()
    }
    
    private func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    private func instantiateHeader() {
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(BuildPartViewController.tappedDone(_:)))
        button.title = "Add"
        
        navigationItem.rightBarButtonItem = button
        navigationItem.title = "Assemblies"
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
        return assemblies.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCells.assembly, for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = assemblies[indexPath.row].name
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let assemblyToDelete = assemblies[indexPath.row]

            FirebaseDataManager.delete(assembly: assemblyToDelete)
            
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
        
        selectedAssembly = assemblies[indexPath.row]
        
        performSegue(withIdentifier: Constants.Segues.AssemblyDetail, sender: self)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Constants.Segues.AssemblyDetail) {
            
            let viewController = segue.destination as! AssemblyDetailTableViewController
            
            viewController.assembly = selectedAssembly
            
        }
    }
}
