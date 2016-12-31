//
//  AssemblyDetailViewController
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/27/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit

class AssemblyDetailTableViewController: UITableViewController, UIGestureRecognizerDelegate {

    var assembly: Assembly? = nil
    
    var parts: [Part] = []
    
    var builds: [Build] = []

    var selectedPart: Part? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let a = assembly else {
            return
        }
        
        self.title = a.name
        
        FirebaseDataManager.sharedInstance.getParts(for: a) {
            part in

            self.parts.append(part)
            self.reloadData()
        }
        
        /*FirebaseDataManager.sharedInstance.getBuilds(for: a) {
            build in
            
            self.builds.append(build)
            self.reloadData()
        }*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let row = tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: row, animated: false)
        }
    }
    
    @IBAction func unwindToAssemblyDetail(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? CreateBuildViewController {
            
            guard let a = assembly else {
                return
            }

            let rows = sourceViewController.form.values()
            
            if let build = Build(scheduledFor: (rows["Date"] as? Date)!, with: a.databaseID) {
                
                builds.append(build)

                FirebaseDataManager.sharedInstance.add(build: build)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let identifier = segue.identifier else {
            return
        }

        switch identifier {
        case (Constants.Segues.PartDetail):
            let viewController = segue.destination as! PartViewController
            
            viewController.part = selectedPart
        case Constants.Segues.CreateBuild: break

        default: break
        }
    }

    // Table view
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Builds" : "Parts"
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let v = UITableViewHeaderFooterView()

        if ( section == 0) {
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleBuildTap))
            tapRecognizer.delegate = self
            tapRecognizer.numberOfTapsRequired = 1
            tapRecognizer.numberOfTouchesRequired = 1
            v.addGestureRecognizer(tapRecognizer)
        }

        return v
    }
    
    func handleBuildTap(gestureRecognizer: UIGestureRecognizer) {
         performSegue(withIdentifier: Constants.Segues.CreateBuild, sender: self)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? builds.count : parts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCells.part)! as UITableViewCell
        
        cell.textLabel?.text = parts[indexPath.row].name
        cell.detailTextLabel?.text = parts[indexPath.row].manufacturer
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {

        let indexPath = tableView.indexPathForSelectedRow!
        
        selectedPart = parts[indexPath.row]
        
        performSegue(withIdentifier: Constants.Segues.PartDetail, sender: self)
    }
}
