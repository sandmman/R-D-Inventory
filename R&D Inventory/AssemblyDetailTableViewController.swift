//
//  AssemblyDetailViewController
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/27/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit
import Eureka

class AssemblyDetailTableViewController: UITableViewController, UIGestureRecognizerDelegate {

    var assembly: Assembly? = nil
    
    var parts: [Part] = []
    
    var builds: [Build] = []

    var selectedPart: Part? = nil
    
    var selectedBuild: Build? = nil

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
        
        FirebaseDataManager.sharedInstance.getBuilds(for: a) {
            build in
            
            self.builds.append(build)
            self.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let row = tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: row, animated: false)
        }
    }
    
    @IBAction func unwindToAssemblyDetail(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? CreateBuildViewController {

            guard let row: DateInlineRow = sourceViewController.form.rowBy(tag: Constants.BuildFields.Date) else {
                return
            }
            
            guard let title_row: TextRow = sourceViewController.form.rowBy(tag: Constants.BuildFields.Title) else {
                return
            }

            guard let date = row.value, let title = title_row.value else {
                return
            }

            guard let a = assembly else {
                return
            }

            let partsNeeded: [String: Int] = parts.reduce([:]) {
                
                self.buildPartDict(dict: $0, part: $1, form: sourceViewController.form)
            }

            guard let build = Build(title: title, partsNeeded: partsNeeded, scheduledFor: date, withAssembly: a.databaseID) else {
                return
            }

            builds.append(build)
            
            reloadData()

            FirebaseDataManager.sharedInstance.add(build: build)
        }
    }
    
    private func buildPartDict(dict: [String: Int], part: Part, form: Form) -> [String: Int] {
        
        guard let count = (form.rowBy(tag: part.databaseID) as! StepperRow).value else {
            return dict
        }
        
        var dict = dict

        dict[part.databaseID] = Int(count)

        return dict
    }
    
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        
        return formatter.string(from: date)
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

        case Constants.Segues.BuildDetail:
            let viewController = segue.destination as! BuildDetailViewController
            
            viewController.build = selectedBuild
            viewController.parts = parts

        case Constants.Segues.CreateBuild:
            let viewController = segue.destination as! CreateBuildViewController
            
            viewController.parts = parts

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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            FirebaseDataManager.sharedInstance.delete(build: builds[indexPath.row])
            
            builds.remove(at: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0 ? true : false
    }

    public func handleBuildTap(gestureRecognizer: UIGestureRecognizer) {
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
        
        if indexPath.section == 0 {
            cell.textLabel?.text = builds[indexPath.row].title
            cell.detailTextLabel?.text = formatDate(date: builds[indexPath.row].scheduledDate)
            
        } else {
            cell.textLabel?.text = parts[indexPath.row].name
            cell.detailTextLabel?.text = parts[indexPath.row].manufacturer
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        
        if indexPath.section == 0 {
            selectedBuild = builds[indexPath.row]
            
            performSegue(withIdentifier: Constants.Segues.BuildDetail, sender: self)
        } else {
            selectedPart = parts[indexPath.row]
            
            performSegue(withIdentifier: Constants.Segues.PartDetail, sender: self)
        }
    }
}
