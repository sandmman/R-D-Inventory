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

    var viewModel: ViewModel<Assembly>!

    @IBOutlet weak var AddAssemblyButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ViewModel<Assembly>(project: project, section: 0)
        viewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        reloadCollectionViewData()
        
        viewModel.startSync()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.stopSync()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSectionsInCollectionView()
    }
    
    // MARK: TableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section: section)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let count = viewModel.objectDataSources.0.count

        guard count > indexPath.row else {
            return UITableViewCell()
        }
        
        let model = viewModel.objectDataSources.0.list[indexPath.row]

        return model.cellForTableView(tableView: tableView, at: indexPath)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            
            viewModel.delete(from: tableView, at: indexPath)
            
        }
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.didSelectCell(at: indexPath)
        
        performSegue(withIdentifier: Constants.Segues.AssemblyDetail, sender: self)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.AssemblyDetail, let viewController = segue.destination as? AssemblyDetailTableViewController {

            viewController.viewModel = AssemblyDetailViewModel(project: project, assembly: viewModel.section1SelectedCell!)
            
        } else if (segue.identifier == Constants.Segues.CreateAssembly), let viewController = segue.destination as? CreateAssemblyViewController {
            
            viewController.project = viewModel.project
        }
    }
    
    // MARK: - Private

    private func reloadCollectionViewData(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension AssemblyTableViewController: TabBarViewController, FirebaseTableViewDelegate {
    
    
    public func didChangeProject(project: Project) {
        self.project = project
        
        guard let model = viewModel else {
            return
        }

        model.project = project
    }
}
