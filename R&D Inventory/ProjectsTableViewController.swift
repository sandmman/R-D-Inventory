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
    
    @IBAction func cancel(sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        listener = ListenerHandler()
        listener.listenForProjects(onComplete: didReceiveProject)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        listener.removeListeners()
    }

    private func didReceiveProject(project: Project) {
        if let index = projects.index(of: project) {
            self.projects[index] = project
        } else {
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

        performSegue(withIdentifier: Constants.Segues.UnwindToProjectDetail, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}
