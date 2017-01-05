//
//  BuildTableViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/1/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class BuildTableViewController: UITableViewController, TabBarViewController {
    
    var project: Project!
    
    private var builds = [Build]()
    
    private var listener: ListenerHandler!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listener = ListenerHandler()
        listener.listenForBuilds(for: project, onComplete: didReceiveBuild)
    }

    override func viewDidDisappear(_ animated: Bool) {
        listener.removeListeners()
    }
    
    public func didChangeProject(project: Project) {
        self.project = project
        builds = []
    }

    private func didReceiveBuild(build: Build) {
        if let index = builds.index(of: build) {
            self.builds[index] = build
        } else {
            self.builds.append(build)
        }
        
        self.reloadTable()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return builds.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuildTableViewCell", for: indexPath)

        cell.textLabel?.text = builds[indexPath.row].title
        cell.detailTextLabel?.text = builds[indexPath.row].scheduledDate.description

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // Delete row
        if editingStyle == .delete {

            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - Navigation

    @IBAction func unwindToBuildTableViewController(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? CreateBuildViewController {
            
            guard let build = sourceViewController.newBuild else {
                return
            }
            
            builds.append(build)
            
            reloadTable()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CreateBuildViewController {
            destination.project = project
            destination.generic = true
        }
    }

}
