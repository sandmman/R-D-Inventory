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
    
    @IBOutlet var tableView: UITableView!
    
    fileprivate(set) var viewModel: ProjectViewModel!

    fileprivate(set) var project: Project!

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let _ = segue.identifier, let destination = segue.destination as? BuildDetailViewController else {
            return
        }

        destination.build = viewModel.section2SelectedCell
    }

    // MARK: Private Helpers
    
    fileprivate func configureView() {
        guard let proj = project else {
            return
        }
        
        projectLabel?.text = proj.name
    }
    
    fileprivate func reloadData() {
        DispatchQueue.main.async {
            if let table = self.tableView {
                table.reloadData()
            }
        }
    }
}

extension ProjectViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Part Warnings": "Upcoming Builds"
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 1 {
            viewModel.didSelectCell(at: indexPath)
            performSegue(withIdentifier: Constants.Segues.BuildDetail, sender: nil)
        }
        
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
        cell.detailTextLabel?.text = viewModel.objectDataSources.0.list[indexPath.row].type.rawValue

        return cell
    }
}

extension ProjectViewController: TabBarViewController, FirebaseTableViewDelegate {
    
    public func didChangeProject(project: Project) {
        self.project = project
        
        configureView()

        viewModel?.project = project
        viewModel?.stopSync()

        reloadData()
    }

}
