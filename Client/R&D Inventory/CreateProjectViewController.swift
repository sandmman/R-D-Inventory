//
//  ProjectViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/3/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit
import Eureka

class CreateProjectViewController: FormViewController {
    
    var project: Project? = nil
    
    var isInitialForm = false

    @IBOutlet weak var saveProjectButton: UIBarButtonItem!
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        guard let row: TextRow = form.rowBy(tag: Constants.ProjectFields.Name),
            let name = row.value,
            let proj = Project(name: name) else {
                return
        }
        
        project = proj
        
        FirebaseDataManager.save(project: proj)
        
        navigate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instantiateForm()

        if !isInitialForm { instantiateDoneButton() }
    }

    private func instantiateDoneButton() {
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(CreateProjectViewController.save(_:)))
        button.title = "Done"
        navigationItem.rightBarButtonItem = button
    }

    private func instantiateForm() {
        form.append(Section("Info"))
        
        let row = TextRow(Constants.ProjectFields.Name){ row in
                row.title = Constants.ProjectFields.Name
                row.placeholder = ""
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
            }
        
        form.allSections.first!.append(row)
        
    }
    
    private func navigate() {
        if isInitialForm {
            
            let storyboard:UIStoryboard = UIStoryboard(name: "TabBar", bundle: nil)
            
            let tabBar: UITabBarController = storyboard.instantiateInitialViewController() as! UITabBarController
            
            guard let proj = project else {
                return
            }
            
            guard let navController0 = tabBar.viewControllers![0] as? UINavigationController,let vc0 = navController0.topViewController as? TabBarViewController else {
                return
            }
            
            guard let navController1 = tabBar.viewControllers![1] as? UINavigationController, let vc1 = navController1.topViewController as? TabBarViewController else {
                return
            }
            
            guard let navController2 = tabBar.viewControllers![2] as? UINavigationController,
                let vc2 = navController2.topViewController as? TabBarViewController else {
                    return
            }
            
            guard let navController3 = tabBar.viewControllers![3] as? UINavigationController,
                let vc3 = navController3.topViewController as? TabBarViewController else {
                    return
            }
            
            vc0.didChangeProject(project: proj)
            vc1.didChangeProject(project: proj)
            vc2.didChangeProject(project: proj)
            vc3.didChangeProject(project: proj)

            UIApplication.shared.keyWindow?.rootViewController = tabBar

        } else {
            _ = navigationController?.popViewController(animated: true)

        }
    }
}
