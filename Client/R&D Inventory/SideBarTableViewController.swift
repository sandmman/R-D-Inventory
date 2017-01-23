//
//  SideBarTableViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/2/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit
import SideMenu

class SideBarTableViewController: UITableViewController, FirebaseTableViewDelegate {
    
    var viewModel: ViewModel<Project>!
    
    @IBAction func cancel(sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSideBar()

        viewModel = ViewModel<Project>(section: 0)
        
        viewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        reloadCollectionViewData()
        viewModel.startSync()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.stopSync()
    }

    // MARK: - TableView
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 160
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 65
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "SideBarTableViewCell") as! SideBarTableViewCell
        
        headerCell.nameLabel.text = CurrentUser.fullName
        headerCell.emailLabel.text = CurrentUser.email.lowercased()

        return headerCell.contentView
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let  footerCell = tableView.dequeueReusableCell(withIdentifier: "SideBarFooterTableViewCell") as! SideBarFooterTableViewCell
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SideBarTableViewController.createProject(_:)))
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 1
        footerCell.addGestureRecognizer(tapGesture)
        
        return footerCell.contentView
    }
    
    @objc private func createProject(_ sender: UIGestureRecognizer) {
        performSegue(withIdentifier: Constants.Segues.CreateProject, sender: nil)
    }
    
    // MARK: - TableView

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSectionsInCollectionView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.objectDataSources.0.list[indexPath.row]
        return model.cellForTableView(tableView: tableView, at: indexPath)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            viewModel.delete(from: tableView, at: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.didSelectCell(at: indexPath)

        performSegue(withIdentifier: Constants.Segues.UnwindToProjectDetail, sender: nil)
    }
    
    // MARK: - Private
    
    private func reloadCollectionViewData(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func configureSideBar() {
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width;
        
        SideMenuManager.menuWidth = screenWidth * 0.70
        
        SideMenuManager.menuFadeStatusBar = false
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

