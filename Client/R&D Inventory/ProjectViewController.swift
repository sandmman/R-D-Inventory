//
//  ProjectViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/4/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController {
    
    @IBOutlet var projectLabel: UILabel!
    
    @IBOutlet var warningsTableView: UITableView!
    
    var viewModel: ProjectViewModel!

    var project: Project!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()

        viewModel = ProjectViewModel(project: project, section: 1)
        
        viewModel.delegate = self    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        reloadData()

        viewModel.startSync()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.stopSync()
    }

    // MARK: Private Helpers
    
    internal func configureView() {
        guard let proj = project else {
            return
        }

        projectLabel?.text = proj.name
    }

    private func reloadData() {
        DispatchQueue.main.async {
            if let table = self.warningsTableView {
                table.reloadData()
            }
        }
    }
    
    // MARK: Navigation

    @IBAction func unwindToTabBarController(sender: UIStoryboardSegue) {
        if let vc = sender.source as? SideBarTableViewController {
            
            guard let project = vc.viewModel.section1SelectedCell else {
                return
            }
            
            guard let tabBar = tabBarController else {
                return
            }
            
            guard let navController0 = tabBar.viewControllers![1] as? UINavigationController,let vc0 = navController0.topViewController as? TabBarViewController else {
                return
            }
            
            guard let navController1 = tabBar.viewControllers![2] as? UINavigationController, let vc1 = navController1.topViewController as? TabBarViewController else {
                return
            }
            
            guard let navController2 = tabBar.viewControllers![3] as? UINavigationController,
                let vc2 = navController2.topViewController as? TabBarViewController else {
                    return
            }
            
            vc0.didChangeProject(project: project)
            vc1.didChangeProject(project: project)
            vc2.didChangeProject(project: project)
            
            didChangeProject(project: project)
        }
    }
}

extension ProjectViewController: UITableViewDelegate,UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Part Warnings": "Upcoming Builds"
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section: section)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSectionsInCollectionView()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCells.BuildWarning, for: indexPath)
        
        cell.textLabel?.text = viewModel.objectDataSources.0.list[indexPath.row].title
        
        return cell
    }
}

extension ProjectViewController: TabBarViewController {
    
    public func didChangeProject(project: Project) {
        self.project = project
        
        configureView()
        
        viewModel?.project = project

    }

}

extension ProjectViewController: FirebaseTableViewDelegate {
    func indexAdded<T: FIRDataObject>(at indexPath: IndexPath, data: T) {
        warningsTableView.insertRows(at: [indexPath], with: .none)
    }
    
    func indexChanged<T: FIRDataObject>(at indexPath: IndexPath, data: T) {
        warningsTableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func indexRemoved(at indexPath: IndexPath, key: String) {
        warningsTableView.deleteRows(at: [indexPath], with: .none)
    }
    
    func indexMoved<T: FIRDataObject>(at indexPath: IndexPath, to toIndexPath: IndexPath, data: T) {
        warningsTableView.moveRow(at: indexPath, to: toIndexPath)
    }
}