//
//  ProjectViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/4/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController, TabBarViewController {
    
    @IBOutlet var projectLabel: UILabel!

    var project: Project!

    override func viewDidLoad() {
        super.viewDidLoad()

        projectLabel.text = "Project Name"
    }
    
    public func didChangeProject(project: Project) {
        self.project = project
        
        projectLabel.text = project.name

    }
    
    @IBAction func unwindToTabBarController(sender: UIStoryboardSegue) {
        if let vc = sender.source as? ProjectsTableViewController {
            
            guard let project = vc.selectedProject else {
                return
            }
            
            guard let tabBar = tabBarController else {
                return
            }
            
            guard let navController0 = tabBar.viewControllers![1] as? UINavigationController,let vc0 = navController0.topViewController as? InventoryTableViewController else {
                return
            }
            
            guard let navController1 = tabBar.viewControllers![2] as? UINavigationController, let vc1 = navController1.topViewController as? BuildTableViewController else {
                return
            }
            
            guard let navController2 = tabBar.viewControllers![3] as? UINavigationController,
                let vc2 = navController2.topViewController as? AssemblyTableViewController else {
                    return
            }
            
            vc0.didChangeProject(project: project)
            vc1.didChangeProject(project: project)
            vc2.didChangeProject(project: project)
            
            didChangeProject(project: project)
        }
    }
}
