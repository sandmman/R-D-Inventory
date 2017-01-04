//
//  ProjectsTableViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/2/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class ProjectsTableViewController: UITableViewController {
    
    var handles: (UInt, UInt)!
    
    var projects = [Project]()
    
    var selectedProject: Project? = nil
    
    var listener: ListenerHandler!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        listener = ListenerHandler()
        listener.listenForProjects(onComplete: receivedProject)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        listener.removeListeners()
    }

    private func receivedProject(project: Project) {
        var found = false

        for i in 0..<self.projects.count {
            if project.key == self.projects[i].key {
                found = true
                self.projects[i] = project
                break
            }
        }
        
        if !found {
            self.projects.append(project)
        }
        
        self.reloadTable()
    }
    
    private func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCells.Project, for: indexPath)

        cell.textLabel?.text = projects[indexPath.row].name

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            let project = projects[indexPath.row]
    
            projects.remove(at: indexPath.row)
            
            FirebaseDataManager.delete(project: project)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        selectedProject = projects[indexPath.row]

        performSegue(withIdentifier: Constants.Segues.ProjectDetail, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let project = selectedProject else {
            return
        }
        
        guard let tabBarController = segue.destination as? UITabBarController, let navController0 = tabBarController.viewControllers![0] as? UINavigationController, let vc0 = navController0.topViewController as? BuildTableViewController else {
            return
        }
        guard let navController1 = tabBarController.viewControllers![1] as? UINavigationController, let vc1 = navController1.topViewController as? AssemblyTableViewController else {
            return
        }
        guard let navController2 = tabBarController.viewControllers![2] as? UINavigationController, let vc2 = navController2.topViewController as? InventoryTableViewController else {
            return
        }
        
        vc0.project = project
        vc1.project = project
        vc2.project = project
    }
}
