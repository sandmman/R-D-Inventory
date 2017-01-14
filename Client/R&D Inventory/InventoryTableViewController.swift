//
//  InventoryTableViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/1/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class InventoryTableViewController: UITableViewController {

    var project: Project!
    
    fileprivate var viewModel: ViewModel<Part>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ViewModel<Part>(project: project, reloadCollectionViewCallback: reloadCollectionViewData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadCollectionViewData()
        viewModel.startSync()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.stopSync()
    }

    // MARK: - TableView

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCells.Part, for: indexPath) as! PartTableViewCell
        
        let obj = viewModel.objectDataSource.list[indexPath.row]

        cell.nameTextLabel?.text = obj.name
        cell.manufacturerTextLabel?.text = obj.manufacturer
        cell.count = obj.countInStock

        cell.indexPath = indexPath
        cell.delegate = self

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            viewModel.delete(from: tableView, at: indexPath)
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.CreatePart, let dest = segue.destination as? CreatePartViewController {
            
            dest.project = project
            
        }
    }
    
    // MARK: - Private
    
    private func reloadCollectionViewData(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension InventoryTableViewController: TabBarViewController, PartTableViewCellDelegate {
    
    public func didChangeProject(project: Project) {
        self.project = project
        
        guard let model = viewModel else {
            return
        }
        
        model.project = project
    }
    
    public func didChangeQuantityInStock(at indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? PartTableViewCell {
            let value = cell.count
            var part = viewModel.objectDataSource.list[indexPath.row]
            part.countInStock = value!
            FirebaseDataManager.update(object: part)
        }
    }

}
