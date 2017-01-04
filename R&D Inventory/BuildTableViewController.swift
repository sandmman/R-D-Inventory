//
//  BuildTableViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/1/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class BuildTableViewController: UITableViewController {
    
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

    private func didReceiveBuild(build: Build) {
        // MARK -- improve efficiency
        var found = false
    
        for i in 0..<builds.count {
            if build.key == self.builds[i].key {
                found = true
                self.builds[i] = build
                break
            }
        }
    
        if !found {
            self.builds.append(build)
        }
    
        self.reloadData()
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

    func reloadData() {
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
            
            reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CreateBuildViewController {
            destination.project = project
            destination.generic = true
        }
    }

}
