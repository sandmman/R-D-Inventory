//
//  ProjectViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/4/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController {
    
    var project: Project!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToTabBarController(sender: UIStoryboardSegue) {
        if let vc = sender.source as? ProjectsTableViewController {
            
            guard let project = vc.selectedProject else {
                return
            }
            
            guard let tabBar = tabBarController else {
                return
            }
            
            guard let navController0 = tabBar.viewControllers![0] as? UINavigationController,let vc0 = navController0.topViewController as? InventoryTableViewController else {
                return
            }
            
            guard let navController1 = tabBar.viewControllers![1] as? UINavigationController, let vc1 = navController1.topViewController as? BuildTableViewController else {
                return
            }
            
            guard let navController2 = tabBar.viewControllers![2] as? UINavigationController,
                let vc2 = navController2.topViewController as? AssemblyTableViewController else {
                    return
            }
            
            vc0.project = project
            vc1.project = project
            vc2.project = project
        }
    }
}
