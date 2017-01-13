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
    
    var project: Project!

    var assembly: Assembly!
    
    var viewModel: AssemblyDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = AssemblyDetailViewModel(project: project, assembly: assembly, reloadCollectionViewCallback:
        reloadCollectionViewCallback)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let row = tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: row, animated: false)
        }
    }
    
    @IBAction func unwindToAssemblyDetail(sender: UIStoryboardSegue) {
        if let _ = sender.source as? CreateBuildViewController {
            
            reloadCollectionViewCallback()
        }
    }
    
    //MARK: - TableView
    
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
            
            viewModel.delete(from: tableView, at: indexPath)
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0 ? true : false
    }

    public func handleBuildTap(gestureRecognizer: UIGestureRecognizer) {
         performSegue(withIdentifier: Constants.Segues.CreateBuild, sender: self)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSectionsInCollectionView()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCells.part)! as UITableViewCell
        
        if indexPath.section == 0 {
            cell.textLabel?.text = viewModel.builds[indexPath.row].title
            cell.detailTextLabel?.text = viewModel.builds[indexPath.row].displayDate
            
        } else {
            cell.textLabel?.text = viewModel.parts[indexPath.row].name
            cell.detailTextLabel?.text = viewModel.parts[indexPath.row].manufacturer
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {

        viewModel.selectedCell(at: didSelectRowAt)
        
        let segue = didSelectRowAt.section == 0 ? Constants.Segues.BuildDetail : Constants.Segues.PartDetail
        
        performSegue(withIdentifier: segue, sender: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case Constants.Segues.PartDetail:
            let viewController = segue.destination as! PartDetailTableViewController

            viewController.part = viewModel.selectedPart
            
        case Constants.Segues.BuildDetail:
            let viewController = segue.destination as! BuildDetailViewController
            
            viewController.build = viewModel.selectedBuild
            viewController.parts = viewModel.parts
            
        case Constants.Segues.CreateBuild:
            let viewController = segue.destination as! CreateBuildViewController
            
            viewController.viewModel = viewModel.getNextViewModel()

        default: break
        }
    }
    
    // MARK: - Private
    
    private func reloadCollectionViewCallback() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
