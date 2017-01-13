//
//  BuildsCalendarViewController.swift
//  
//
//  Created by Aaron Liberatore on 1/7/17.
//
//

import UIKit
import FSCalendar

class BuildsCalendarViewController: UIViewController {
    
    var project: Project!
    
    var viewModel: BuildsViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeCalendar()
        
        viewModel = BuildsViewModel(project: project, reloadCollectionViewCallback: reloadData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.listenForObjects()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.deinitialize()
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToBuildCalendar(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? CreateBuildViewController {
            
            guard let build = sourceViewController.newBuild else {
                return
            }
            
            viewModel.add(build: build)            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let _ = segue.identifier, let destination = segue.destination as? CreateBuildViewController else {
            return
        }

        destination.viewModel = viewModel.getNextViewModel(nil)

    }
    
    // MARK: Private Functions
    
    private func reloadData() {
        DispatchQueue.main.async {
            if self.tableView != nil && self.calendar != nil {
                self.tableView.reloadData()
                self.calendar.reloadData()
            }
        }
    }
}

extension BuildsCalendarViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    internal func initializeCalendar() {
        
        calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesUpperCase]
        
        calendar.select(Date())
        
        calendar.scrollDirection = .vertical
        
        calendar.appearance.headerTitleFont = UIFont(name: "Arial", size: 10)
        
        calendar.appearance.titleFont = UIFont(name: "Arial", size: 8)
    }
    
    public func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return viewModel.builds[date.display]?.count ?? 0
    }
    
    public func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        viewModel.selected(date: date)
    }
    
    public func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
        guard let day = date.day else {
            return UIColor.darkGray
        }
        
        return day == 1 || day == 7 ? UIColor.lightGray : UIColor.darkGray
    }
}

extension BuildsCalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section: section)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSectionsInCollectionView()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCells.Builds, for: indexPath)
        
        if let buildArr = viewModel.builds[calendar.selectedDate.display] {
            
            cell.textLabel?.text = buildArr[indexPath.row].title
            cell.detailTextLabel?.text = buildArr[indexPath.row].type.rawValue
            
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedCell(at: indexPath)
        performSegue(withIdentifier: Constants.Segues.BuildDetail, sender: nil)
    }
}

extension BuildsCalendarViewController: TabBarViewController {
    
    public func didChangeProject(project: Project) {
        self.project = project

        guard let vm = viewModel else {
            return
        }
        vm.project = project
    }

}
