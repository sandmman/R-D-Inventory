//
//  ProjectViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/4/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController, TabBarViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var projectLabel: UILabel!
    
    @IBOutlet var warningsTableView: UITableView!
    
    private var buildWarnings = [Build]()

    var project: Project!

    override func viewDidLoad() {
        super.viewDidLoad()

        projectLabel.text = "Project Name"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        warningsTableView.isHidden = buildWarnings.count == 1
        
        if let proj = project {
            projectLabel.text = proj.name

        }
    }
    
    // MARK: Private Helpers

    public func didChangeProject(project: Project) {
        self.project = project
        
        if let lbl = projectLabel {
            lbl.text = project.name
        }
        
        reloadData()
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
            
            guard let project = vc.selectedProject else {
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
    
    // MARK: TableView
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Part Warnings": "Upcoming Builds"
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buildWarnings.count
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCells.BuildWarning, for: indexPath)
        
        cell.textLabel?.text = buildWarnings[indexPath.row].assemblyID
        
        return cell
    }
}
