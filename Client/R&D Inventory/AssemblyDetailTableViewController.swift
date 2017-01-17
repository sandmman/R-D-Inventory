//
//  AssemblyDetailViewController
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/27/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit
import Eureka

class AssemblyDetailTableViewController: UITableViewController, UIGestureRecognizerDelegate, FirebaseTableViewDelegate {
    
    var viewModel: AssemblyDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.reloadData()

        viewModel.startSync()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.stopSync()
    }

    @IBAction func unwindToAssemblyDetail(sender: UIStoryboardSegue) {
        
    }
    
    //MARK: - TableView
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Parts" : "Builds"
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
        return indexPath.section == 0 ? false : true
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
        if indexPath.section == 0 {
            
            let count = viewModel.parts.list.count

            guard count > indexPath.row else {
                return UITableViewCell()
            }
            
            let part = viewModel.parts.list[indexPath.row]

            return part.cellForTableView(tableView: tableView, at: indexPath)
            
        } else {

            let count = viewModel.builds.list.count

            guard count > indexPath.row else {
                return UITableViewCell()
            }
            
            let build = viewModel.builds.list[indexPath.row]

            return build.cellForTableView(tableView: tableView, at: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {

        viewModel.didSelectCell(at: didSelectRowAt)
        
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
            //viewController.parts = viewModel.parts
            
        case Constants.Segues.CreateBuild:
            let viewController = segue.destination as! CreateBuildViewController
            
            viewController.viewModel = viewModel.getNextViewModel()

        default: break
        }
    }
    
    // MARK: - Private
    
    fileprivate func reloadCollectionViewCallback() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
